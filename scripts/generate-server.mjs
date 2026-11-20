// Reproducible Serverpod generation without installing Flutter for the web MVP.
import { cp, readFile, writeFile } from "node:fs/promises";
import { spawnSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { prepareRuntime, runtime } from "./dev.mjs";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const dart = process.env.DART_EXECUTABLE || "dart";
const env = {
  ...process.env,
  PUB_CACHE: path.join(root, "tmp", "pub-cache"),
  CI: "true",
};
// Serverpod's supported CI path skips its global Flutter prerequisite. This
// isolated workspace contains only the server and generated Dart client.
env.PATH = `${path.dirname(dart)}${path.delimiter}${env.PATH || ""}`;
function run(args, cwd) {
  const result = spawnSync(dart, args, {
    cwd,
    env,
    stdio: "inherit",
    windowsHide: true,
  });
  if (result.error) throw result.error;
  if (result.status !== 0)
    throw Error(`Dart command failed (${result.status}).`);
}

const server = await prepareRuntime();
await cp(
  path.join(root, "caregrid_client"),
  path.join(runtime, "caregrid_client"),
  {
    recursive: true,
    filter: (file) => !file.includes(".dart_tool"),
  },
);
await writeFile(
  path.join(runtime, "pubspec.yaml"),
  "name: caregrid_web_runtime\nenvironment:\n  sdk: ^3.12.2\nworkspace:\n  - caregrid_server\n  - caregrid_client\n",
);
run(["pub", "get"], runtime);
run(
  [
    "pub",
    "global",
    "run",
    "serverpod_cli:serverpod_cli",
    "--no-analytics",
    "--no-interactive",
    "generate",
  ],
  server,
);
const tag = process.argv[2];
if (tag) {
  if (!/^[a-z0-9-]+$/.test(tag)) throw Error("Use a lowercase migration tag.");
  run(
    [
      "pub",
      "global",
      "run",
      "serverpod_cli:serverpod_cli",
      "--no-analytics",
      "--no-interactive",
      "create-migration",
      "--tag",
      tag,
      ...(process.argv.includes("--accept-reviewed-warnings")
        ? ["--force"]
        : []),
    ],
    server,
  );
}
for (const relative of [
  "lib/src/generated",
  "test/integration/test_tools",
  "migrations",
]) {
  await cp(
    path.join(server, relative),
    path.join(root, "caregrid_server", relative),
    { recursive: true },
  );
}
await cp(
  path.join(runtime, "caregrid_client", "lib"),
  path.join(root, "caregrid_client", "lib"),
  { recursive: true },
);

// Preserve Flutter's locked packages while taking the server workspace's exact
// hosted versions/checksums. No dependency upgrades are requested by this tool.
const rootLock = await readFile(path.join(root, "pubspec.lock"), "utf8");
const serverLock = await readFile(path.join(runtime, "pubspec.lock"), "utf8");
const blocks = (lock) =>
  new Map(
    [
      ...lock.matchAll(
        /^  ([a-zA-Z0-9_]+):\r?\n[\s\S]*?(?=^  [a-zA-Z0-9_]+:|^sdks:)/gm,
      ),
    ].map(([block, name]) => [name, block.replace(/\r\n/g, "\n")]),
  );
const merged = blocks(rootLock);
for (const [name, block] of blocks(serverLock)) {
  const previous = merged.get(name);
  const dependency = previous?.match(/^    dependency: (.+)$/m)?.[1];
  merged.set(
    name,
    dependency
      ? block.replace(/^    dependency: .+$/m, `    dependency: ${dependency}`)
      : block,
  );
}
const prefix = rootLock.slice(0, rootLock.indexOf("packages:"));
const suffix = rootLock.slice(rootLock.indexOf("sdks:")).replace(/\r\n/g, "\n");
await writeFile(
  path.join(root, "pubspec.lock"),
  `${prefix}packages:\n${[...merged]
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([, block]) => block)
    .join("")}${suffix}`,
);
console.log(
  "Generated server/client/migrations and preserved the root Flutter lockfile. Review the diff before committing.",
);
