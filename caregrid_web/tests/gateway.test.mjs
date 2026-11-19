import { test } from "node:test";
import assert from "node:assert/strict";
import http from "node:http";
import { createCareGridServer } from "../server.mjs";

async function fixture(t, options = {}) {
  const calls = [];
  let time = Date.parse("2026-11-19T18:00:00Z");
  const fetchImpl = async (url, init) => {
    const args = JSON.parse(init.body);
    calls.push({ path: url.pathname, args, headers: init.headers });
    if (url.pathname === "/account/signIn") {
      if (args.pin !== "1111")
        return Response.json(
          {
            className: "CareGridException",
            data: {
              __className__: "CareGridException",
              code: "forbidden",
              message: "Unknown handle or wrong PIN.",
            },
          },
          { status: 400 },
        );
      return Response.json({
        token: "BACKEND-SECRET",
        user: {
          id: 1,
          handle: args.handle,
          displayName: "Operator",
          role: "command",
          title: "Command",
          pin: "1111",
        },
        expiresAt: new Date(time + 100_000).toISOString(),
      });
    }
    if (url.pathname === "/account/me")
      return Response.json({
        id: 1,
        displayName: "Operator",
        role: "command",
        pin: "1111",
      });
    return Response.json({ ok: true });
  };
  const server = createCareGridServer({
    fetchImpl,
    now: () => time,
    ...options,
  });
  await new Promise((resolve) => server.listen(0, "127.0.0.1", resolve));
  t.after(
    () =>
      new Promise((resolve) => {
        server.close(resolve);
        server.closeAllConnections();
      }),
  );
  const origin = `http://127.0.0.1:${server.address().port}`;
  const request = (pathname, method = "GET", body, extra = {}) =>
    fetch(origin + pathname, {
      method,
      headers: {
        "content-type": "application/json",
        "x-caregrid-request": "1",
        ...extra,
      },
      ...(body !== undefined ? { body: JSON.stringify(body) } : {}),
    });
  const login = async () => {
    const result = await request("/api/session", "POST", {
      handle: "cmd.night",
      pin: "1111",
    });
    return {
      response: result,
      cookie: result.headers.get("set-cookie").split(";")[0],
    };
  };
  return {
    server,
    calls,
    origin,
    request,
    login,
    advance: (milliseconds) => (time += milliseconds),
  };
}
test("web session keeps the backend token and PIN out of browser JSON", async (t) => {
  const f = await fixture(t);
  const { response, cookie } = await f.login();
  const body = await response.text();
  assert.equal(response.status, 200);
  assert.ok(!body.includes("BACKEND-SECRET"));
  assert.ok(!body.includes("1111"));
  assert.match(
    response.headers.get("set-cookie"),
    /HttpOnly; SameSite=Strict; Path=\/api/,
  );
  const result = await f.request(
    "/api/rpc/incident/board",
    "POST",
    {},
    { cookie },
  );
  assert.equal(result.status, 200);
  assert.deepEqual(f.calls.at(-1).args, {});
  assert.equal(f.calls.at(-1).path, "/incident/board");
  assert.equal(f.calls.at(-1).headers.Authorization, "Bearer BACKEND-SECRET");
});
test("RPC requires an unexpired session and logout revokes access", async (t) => {
  const f = await fixture(t);
  assert.equal(
    (await f.request("/api/rpc/incident/board", "POST", {})).status,
    401,
  );
  const { cookie } = await f.login();
  f.advance(110_000);
  assert.equal(
    (await f.request("/api/rpc/incident/board", "POST", {}, { cookie })).status,
    401,
  );
  const fresh = await f.login();
  await f.request("/api/session", "DELETE", undefined, {
    cookie: fresh.cookie,
  });
  assert.equal(
    (
      await f.request("/api/session", "GET", undefined, {
        cookie: fresh.cookie,
      })
    ).status,
    401,
  );
  assert.equal(f.calls.at(-1).path, "/account/signOut");
});
test("cross-origin writes, missing request headers and DNS rebinding are rejected", async (t) => {
  const f = await fixture(t);
  assert.equal(
    (
      await f.request(
        "/api/session",
        "POST",
        { handle: "cmd.night", pin: "1111" },
        { origin: "https://another.example" },
      )
    ).status,
    403,
  );
  assert.equal(
    (
      await fetch(f.origin + "/api/session", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: "{}",
      })
    ).status,
    403,
  );
  const hostileHost = await new Promise((resolve, reject) => {
    const request = http.get(
      f.origin + "/api/accounts",
      { headers: { host: "another.example" } },
      (response) => {
        response.resume();
        resolve(response.statusCode);
      },
    );
    request.on("error", reject);
  });
  assert.equal(hostileHost, 403);
  assert.equal(f.calls.length, 0);
});
test("only explicitly allowed RPC methods and bounded JSON objects are accepted", async (t) => {
  const f = await fixture(t);
  const { cookie } = await f.login();
  assert.equal(
    (await f.request("/api/rpc/admin/reset", "POST", {}, { cookie })).status,
    404,
  );
  assert.equal(
    (
      await f.request(
        "/api/rpc/incident/board",
        "POST",
        { method: "resolve" },
        { cookie },
      )
    ).status,
    400,
  );
  assert.equal(
    (await f.request("/api/rpc/incident/board", "POST", [], { cookie })).status,
    400,
  );
  assert.equal(
    (
      await f.request(
        "/api/rpc/incident/board",
        "POST",
        { value: "x".repeat(33_000) },
        { cookie },
      )
    ).status,
    413,
  );
});
test("Serverpod's typed error envelope is translated without exposing internals", async (t) => {
  const f = await fixture(t);
  const result = await f.request("/api/session", "POST", {
    handle: "cmd.night",
    pin: "0000",
  });
  assert.equal(result.status, 403);
  assert.equal(
    (await result.json()).error.message,
    "Unknown handle or wrong PIN.",
  );
  for (let count = 0; count < 9; count++)
    await f.request("/api/session", "POST", {
      handle: "cmd.night",
      pin: "0000",
    });
  assert.equal(
    (
      await f.request("/api/session", "POST", {
        handle: "cmd.night",
        pin: "0000",
      })
    ).status,
    429,
  );
});
test("an unavailable backend reports failure without synthetic success", async (t) => {
  const f = await fixture(t, {
    fetchImpl: async () => {
      throw Error("sensitive connection details");
    },
  });
  const result = await f.request("/api/accounts");
  assert.equal(result.status, 503);
  const body = await result.text();
  assert.ok(body.includes("backend_unavailable"));
  assert.ok(!body.includes("sensitive"));
});
test("the static surface serves the connected entry and hides gateway source", async (t) => {
  const f = await fixture(t);
  const response = await f.request("/");
  assert.equal(response.status, 200);
  assert.match(await response.text(), /connected.js/);
  assert.match(
    response.headers.get("content-security-policy"),
    /frame-ancestors 'none'/,
  );
  for (const pathname of [
    "/server.mjs",
    "/Server.MJS",
    "/playwright.config.mjs",
    "/tests/gateway.test.mjs",
    "/../README.md",
  ])
    assert.equal((await f.request(pathname)).status, 404);
});
