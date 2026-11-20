// Server-only workspace: the web MVP does not require a Flutter installation.
import { cp, mkdir, readFile, writeFile } from "node:fs/promises";
import { spawn } from "node:child_process";
import { randomBytes } from "node:crypto";
import net from "node:net";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
// Generated workspaces, the pub cache and embedded PostgreSQL write thousands
// of small files. A checkout inside OneDrive/Dropbox makes those writes slow
// enough for Serverpod start-up to time out, so the location is configurable.
export const workDir = process.env.CAREGRID_WORK_DIR
  ? path.resolve(process.env.CAREGRID_WORK_DIR)
  : path.join(root, "tmp");
export const runtime = path.join(workDir, "server-runtime");
export const pubCache = process.env.PUB_CACHE || path.join(workDir, "pub-cache");
export async function prepareRuntime() {
  await mkdir(runtime, { recursive: true });
  const destination = path.join(runtime, "caregrid_server");
  await mkdir(destination, { recursive: true });
  for (const directory of [
    "lib",
    "bin",
    "config",
    "migrations",
    "test",
    "web",
  ]) {
    await cp(
      path.join(root, "caregrid_server", directory),
      path.join(destination, directory),
      { recursive: true },
    );
  }
  await cp(
    path.join(root, "caregrid_server", "pubspec.yaml"),
    path.join(destination, "pubspec.yaml"),
  );
  await cp(
    path.join(root, "caregrid_server", "analysis_options.yaml"),
    path.join(destination, "analysis_options.yaml"),
  );
  await cp(
    path.join(root, "caregrid_server", "dart_test.yaml"),
    path.join(destination, "dart_test.yaml"),
  );
  await cp(path.join(root, "pubspec.lock"), path.join(runtime, "pubspec.lock"));
  await writeFile(
    path.join(runtime, "pubspec.yaml"),
    "name: caregrid_web_runtime\nenvironment:\n  sdk: ^3.12.2\nworkspace:\n  - caregrid_server\n",
  );
  const passwordsPath = path.join(destination, "config", "passwords.yaml");
  try {
    await readFile(passwordsPath);
  } catch {
    // Local credentials stay in ignored tmp/. Never use these for a deployment.
    const password = randomBytes(32).toString("hex");
    await writeFile(
      passwordsPath,
      `development:\n  database: ${password}\n  serviceSecret: ${randomBytes(32).toString("hex")}\ntest:\n  database: ${password}\n  serviceSecret: ${randomBytes(32).toString("hex")}\n`,
    );
  }
  return destination;
}

async function main() {
  const dart = process.env.DART_EXECUTABLE || "dart";
  if (!process.argv.includes("--prepare-only")) {
    for (const port of [8080, 8081, 8082, Number(process.env.PORT || 4173)]) {
      await new Promise((resolve, reject) => {
        const probe = net.createServer();
        probe.once("error", () =>
          reject(
            Error(
              `Port ${port} is in use. Stop the previous CareGrid process or choose an unused configuration before starting another copy.`,
            ),
          ),
        );
        probe.listen(port, "127.0.0.1", () => probe.close(resolve));
      });
    }
  }
  const destination = await prepareRuntime();
  const environment = {
    ...process.env,
    PUB_CACHE: pubCache,
  };
  const children = new Set();
  let stopping = false;
  function stop(code = 0) {
    if (stopping) return;
    stopping = true;
    for (const child of children) {
      if (process.platform === "win32" && child.pid) {
        // Kill only a process tree created by this launcher. Dart's CLI starts
        // a VM child on Windows, so terminating just the CLI leaks the API.
        const cleanup = spawn(
          "taskkill.exe",
          ["/PID", String(child.pid), "/T", "/F"],
          { stdio: "ignore", windowsHide: true },
        );
        cleanup.on("error", () => child.kill("SIGTERM"));
      } else child.kill("SIGTERM");
    }
    process.exitCode = code;
  }
  for (const signal of ["SIGINT", "SIGTERM"]) process.on(signal, () => stop());
  function launch(command, args, cwd) {
    const child = spawn(command, args, {
      cwd,
      env: environment,
      stdio: "inherit",
      windowsHide: true,
    });
    children.add(child);
    child.on("error", (error) => {
      console.error(error.message);
      stop(1);
    });
    child.on("exit", (code) => {
      children.delete(child);
      if (!stopping && code) stop(code);
    });
    return child;
  }
  const dependencies = launch(dart, ["pub", "get"], runtime);
  const exitCode = await new Promise((resolve) =>
    dependencies.on("exit", resolve),
  );
  if (exitCode !== 0 || stopping) return;
  if (process.argv.includes("--prepare-only")) return;
  console.log(
    "Starting the local CareGrid API and connected console. All campus data is synthetic.",
  );
  const backend = launch(
    dart,
    ["run", "bin/main.dart", "--apply-migrations"],
    destination,
  );
  backend.on("exit", (code) => stop(code || 0));
  // Wait for the API and seeding before exposing the connected workspace.
  let ready = false;
  const startupDeadline = Date.now() + 180_000;
  while (Date.now() < startupDeadline && !stopping) {
    try {
      const response = await fetch(
        "http://127.0.0.1:8080/account/demoAccounts",
        {
          method: "POST",
          headers: { "content-type": "application/json" },
          body: "{}",
          signal: AbortSignal.timeout(1000),
        },
      );
      if (response.ok && (await response.json()).length) {
        ready = true;
        break;
      }
    } catch {
      /* Compilation, migration and first-boot seeding can take time. */
    }
    await new Promise((resolve) => setTimeout(resolve, 1000));
  }
  if (!ready) {
    if (!stopping)
      console.error(
        "The backend did not become ready within three minutes. Check the API log above.",
      );
    stop(1);
    return;
  }
  const web = launch(process.execPath, ["caregrid_web/server.mjs"], root);
  web.on("exit", (code) => stop(code || 0));
}
if (
  process.argv[1] &&
  path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)
) {
  main().catch((error) => {
    console.error(error.message);
    process.exitCode = 1;
  });
}
