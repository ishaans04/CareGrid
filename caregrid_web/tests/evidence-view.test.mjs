import { test } from "node:test";
import assert from "node:assert/strict";
import { EvidenceController, renderEvidence } from "../evidence-view.mjs";

const key = "a".repeat(64);
const file = {
  key,
  sha256: "b".repeat(64),
  mediaType: "image/png",
  byteLength: 3,
  generation: "1234567890123456789",
  metageneration: "1",
  createdAt: "2026-11-20T06:00:00Z",
};
const page = {
  status: "ready",
  files: [file],
  notice: "Private attachments",
  nextPageToken: null,
};
const deferred = () => {
  let resolve;
  const promise = new Promise((r) => (resolve = r));
  return { promise, resolve };
};
const controller = (rpc, options = {}) => {
  const instance = new EvidenceController({ rpc, ...options });
  instance.context({ incidentId: 17, userId: 1 });
  return instance;
};

test("private panel escapes text and places bytes only in an image preview", () => {
  const html = renderEvidence({
    page: { ...page, notice: '<img src=x onerror="bad()">' },
    error: "<script>bad()</script>",
  });
  assert.ok(html.includes("&lt;script&gt;"));
  assert.ok(!html.includes("<script>"));
  assert.ok(!html.includes("<img src=x"));
  assert.ok(html.includes("COMMAND ONLY"));
  assert.ok(html.includes("512 KiB"));
  assert.ok(!html.includes("data:image"));
  assert.ok(
    renderEvidence({
      page: { status: "disabled", files: [], notice: "Storage is disabled" },
    }).includes("Storage is disabled"),
  );
});

test("case/session changes discard a delayed preview and disable old actions", async () => {
  const gate = deferred();
  const instance = controller(async (_, method) =>
    method === "list" ? page : gate.promise,
  );
  await instance.load();
  const pending = instance.read(key);
  instance.context({ incidentId: 18, userId: 1 });
  gate.resolve({ file, base64Data: "YWJj" });
  await pending;
  assert.equal(instance.snapshot.preview, null);
  assert.equal(instance.snapshot.page, null);
  assert.equal(instance.snapshot.busy, false);
});

test("upload refresh cannot write results into a different case", async () => {
  const gate = deferred();
  let lists = 0;
  const instance = controller(async (_, method) =>
    method === "list" ? (++lists === 1 ? page : gate.promise) : file,
  );
  await instance.load();
  const upload = instance.upload(
    new File(["abc"], "private-name.png", { type: "image/png" }),
  );
  await new Promise(setImmediate);
  instance.context({ incidentId: 18, userId: 1 });
  gate.resolve(page);
  await upload;
  assert.equal(instance.snapshot.page, null);
  assert.equal(instance.snapshot.preview, null);
});

test("private preview expires after sixty seconds and clears on connection loss", async () => {
  let time = 0,
    expire;
  const instance = controller(
    async (_, method) =>
      method === "list" ? page : { file, base64Data: "YWJj" },
    {
      now: () => time,
      schedule: (fn, delay) => {
        assert.equal(delay, 60_000);
        expire = fn;
        return 1;
      },
      cancel: () => {},
    },
  );
  await instance.load();
  await instance.read(key);
  assert.ok(instance.snapshot.preview);
  time = 60_000;
  assert.equal(instance.snapshot.preview, null);
  expire();
  assert.equal(instance.preview, null);
  await instance.read(key);
  assert.ok(instance.snapshot.preview);
  instance.context({ incidentId: 17, userId: 1, offline: true });
  assert.equal(instance.preview, null);
  assert.equal(instance.page, null);
});

test("storage failure stays local and does not retain preview data or busy state", async () => {
  const instance = controller(async () => {
    throw Error("Storage unavailable");
  });
  await instance.load();
  assert.equal(instance.snapshot.error, "Storage unavailable");
  assert.equal(instance.snapshot.busy, false);
  assert.equal(instance.snapshot.preview, null);
});

test("invalid uploads and changed generation/hash metadata are rejected", async () => {
  let uploads = 0;
  const instance = controller(async (_, method) => {
    if (method === "list") return page;
    if (method === "upload") {
      uploads++;
      return file;
    }
    return { file: { ...file, sha256: "c".repeat(64) }, base64Data: "YWJj" };
  });
  await instance.load();
  await instance.upload(
    new File(["<svg/>"], "bad.svg", { type: "image/svg+xml" }),
  );
  assert.equal(uploads, 0);
  assert.match(instance.snapshot.error, /PNG or JPEG/);
  await instance.read(key);
  assert.equal(instance.snapshot.preview, null);
  assert.match(instance.snapshot.error, /verified/);
});

test("removal sends the selected immutable generation and reloads the list", async () => {
  let removed = false;
  const instance = controller(async (_, method, args) => {
    if (method === "remove") {
      assert.deepEqual(args, {
        incidentId: 17,
        key,
        generation: file.generation,
      });
      removed = true;
      return null;
    }
    return { ...page, files: removed ? [] : [file] };
  });
  await instance.load();
  await instance.remove(key);
  assert.equal(instance.snapshot.page.files.length, 0);
  assert.equal(instance.snapshot.busy, false);
});

test("pagination replaces the current page without changing the incident", async () => {
  const instance = controller(async (_, method, args) => {
    assert.equal(args.incidentId, 17);
    assert.equal(method, "list");
    return {
      ...page,
      files: args.pageToken ? [] : [file],
      nextPageToken: args.pageToken ? null : "opaque-token",
    };
  });
  await instance.load();
  await instance.load(instance.snapshot.page.nextPageToken);
  assert.equal(instance.snapshot.hasPrevious, true);
  assert.equal(instance.snapshot.page.files.length, 0);
});
