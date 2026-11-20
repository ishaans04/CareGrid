import http from "node:http";
import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { randomBytes } from "node:crypto";
import {
  cloudConfigFromEnvironment,
  googleBackendHeaders,
} from "./cloud-auth.mjs";

const root = path.dirname(fileURLToPath(import.meta.url));
const types = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".mjs": "text/javascript; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".woff2": "font/woff2",
};
const publicFiles = new Set([
  "index.html",
  "connected.html",
  "styles.css",
  "connected.css",
  "app.js",
  "connected.js",
  "domain.mjs",
  "connected-domain.mjs",
]);
// Explicit surface only. Serverpod enforces role and ownership checks.
const methods = new Set([
  "incident/board",
  "incident/detail",
  "incident/claim",
  "incident/confirmDispatch",
  "incident/escalate",
  "incident/addNote",
  "incident/dismiss",
  "incident/resolve",
  "campus/twin",
  "campus/route",
  "care/cases",
  "care/markReady",
  "responder/home",
  "responder/acknowledge",
  "responder/enRoute",
  "responder/arrive",
  "responder/startCare",
  "responder/complete",
  "responder/decline",
  "responder/setAvailability",
  "sos/raise",
  "sos/mine",
  "sos/cancel",
  "simulation/status",
  "simulation/start",
  "simulation/stop",
  "simulation/clear",
  "readiness/scenarios",
  "readiness/run",
  "readiness/runAll",
  "readiness/history",
  "readiness/applyFix",
  "analytics/metrics",
  "admin/auditLog",
]);
const safeUser = (user) =>
  Object.fromEntries(
    ["id", "handle", "displayName", "role", "title", "responderCode"]
      .filter((key) => key in user)
      .map((key) => [key, user[key]]),
  );
class ApiError extends Error {
  constructor(status, message, code = "request_failed") {
    super(message);
    this.status = status;
    this.code = code;
  }
}
async function readJson(req) {
  if (!/^application\/json(?:;|$)/i.test(req.headers["content-type"] || ""))
    throw new ApiError(415, "Use a JSON request.");
  let size = 0;
  const chunks = [];
  for await (const chunk of req) {
    size += chunk.length;
    if (size > 32_768) throw new ApiError(413, "Request is too large.");
    chunks.push(chunk);
  }
  try {
    const value = JSON.parse(Buffer.concat(chunks).toString());
    if (!value || Array.isArray(value) || typeof value !== "object")
      throw Error();
    return value;
  } catch {
    throw new ApiError(400, "Request must contain a JSON object.");
  }
}

export function createCareGridServer({
  backendUrl = process.env.CAREGRID_API_URL || "http://127.0.0.1:8080/",
  fetchImpl = fetch,
  sessionLifetimeMs = 8 * 60 * 60 * 1000,
  now = Date.now,
  cloud = null,
  backendHeaders = async () => ({}),
} = {}) {
  const cloudOrigin = cloud ? new URL(cloud.origin) : null;
  if (
    cloud &&
    (cloudOrigin.protocol !== "https:" ||
      cloudOrigin.origin !== cloud.origin ||
      !cloud.firebase?.projectId ||
      cloud.firebase.authDomain !==
        `${cloud.firebase.projectId}.firebaseapp.com`)
  )
    throw Error("Invalid cloud console configuration.");
  const backend = new URL(backendUrl);
  if (
    !["http:", "https:"].includes(backend.protocol) ||
    backend.username ||
    backend.password ||
    backend.search ||
    backend.hash
  )
    throw Error("Invalid CAREGRID_API_URL.");
  const sessions = new Map();
  const attempts = new Map();
  let nextSweep = 0;
  async function rpc(endpoint, method, args = {}, token) {
    let response;
    try {
      response = await fetchImpl(new URL(`${endpoint}/${method}`, backend), {
        method: "POST",
        redirect: "error",
        signal: AbortSignal.timeout(10_000),
        headers: {
          ...(await backendHeaders()),
          "Content-Type": "application/json",
          ...(token ? { Authorization: `Bearer ${token}` } : {}),
        },
        body: JSON.stringify(args),
      });
    } catch {
      throw new ApiError(
        503,
        "The CareGrid API is unreachable. Start the backend, then reconnect.",
        "backend_unavailable",
      );
    }
    const raw = await response.text();
    let data;
    try {
      data = raw ? JSON.parse(raw) : null;
    } catch {
      throw new ApiError(
        502,
        "The CareGrid API returned an unreadable response.",
        "backend_response",
      );
    }
    if (!response.ok) {
      const exception =
        data?.className === "CareGridException" ? data.data : data;
      if (exception?.__className__ === "CareGridException") {
        const status =
          endpoint === "account" && method === "me"
            ? 401
            : { forbidden: 403, notFound: 404, badRequest: 400 }[
                exception.code
              ] || 409;
        throw new ApiError(
          status,
          String(exception.message).slice(0, 500),
          exception.code,
        );
      }
      if ([401, 403].includes(response.status))
        throw new ApiError(
          response.status,
          "Sign in with an account allowed to perform this action.",
          "unauthorized",
        );
      throw new ApiError(
        502,
        "The backend could not complete this action. Refresh before trying again.",
        "backend_error",
      );
    }
    return data;
  }
  const server = http.createServer(async (req, res) => {
    for (const [key, value] of Object.entries({
      "X-Content-Type-Options": "nosniff",
      "Cache-Control": "no-store",
      "Referrer-Policy": "same-origin",
      "Content-Security-Policy":
        "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; font-src 'self'; img-src 'self' data:; connect-src 'self'; base-uri 'none'; frame-ancestors 'none'; form-action 'self'",
    }))
      res.setHeader(key, value);
    if (cloud) {
      res.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
      res.setHeader("Cross-Origin-Opener-Policy", "same-origin-allow-popups");
      res.setHeader("Strict-Transport-Security", "max-age=31536000");
      res.setHeader(
        "Content-Security-Policy",
        `default-src 'self'; script-src 'self' https://apis.google.com; style-src 'self' 'unsafe-inline'; font-src 'self'; img-src 'self' data:; connect-src 'self' https://identitytoolkit.googleapis.com https://securetoken.googleapis.com https://www.googleapis.com https://${cloud.firebase.authDomain}; frame-src https://${cloud.firebase.authDomain} https://accounts.google.com; base-uri 'none'; frame-ancestors 'none'; form-action 'self'`,
      );
    }
    const json = (status, value) => {
      res.writeHead(status, {
        "Content-Type": "application/json; charset=utf-8",
      });
      res.end(JSON.stringify(value));
    };
    try {
      if (req.url === "/healthz" && ["GET", "HEAD"].includes(req.method))
        return json(200, { status: "ok" });
      const host = req.headers.host;
      const port = server.address()?.port;
      if (
        !(cloud
          ? host === cloudOrigin.host
          : [`127.0.0.1:${port}`, `localhost:${port}`].includes(host))
      )
        throw new ApiError(403, "Use the configured CareGrid address.");
      const url = new URL(req.url, cloud ? cloud.origin : `http://${host}`);
      if (url.origin !== (cloud ? cloud.origin : `http://${host}`))
        throw new ApiError(403, "Use the configured CareGrid address.");
      if (url.pathname.startsWith("/api/")) {
        if (
          req.headers["sec-fetch-site"] === "cross-site" ||
          (req.headers.origin && req.headers.origin !== url.origin)
        )
          throw new ApiError(
            403,
            "This request must come from the CareGrid console.",
          );
        if (!["GET", "POST", "DELETE"].includes(req.method))
          throw new ApiError(405, "Method not allowed.");
        if (req.method !== "GET" && req.headers["x-caregrid-request"] !== "1")
          throw new ApiError(403, "Missing CareGrid request header.");
        if (now() > nextSweep) {
          for (const [key, session] of sessions)
            if (session.expires <= now()) sessions.delete(key);
          for (const [key, attempt] of attempts)
            if (attempt.reset <= now()) attempts.delete(key);
          nextSweep = now() + 60_000;
        }
        const sessionId = /(?:^|;\s*)caregrid_session=([A-Za-z0-9_-]+)/.exec(
          req.headers.cookie || "",
        )?.[1];
        const session = sessions.get(sessionId);
        const authenticated = () => {
          if (cloud) {
            const token =
              /^Bearer ([A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+)$/.exec(
                req.headers.authorization || "",
              )?.[1];
            if (!token || token.length > 16384)
              throw new ApiError(
                401,
                "Sign in with your campus Google account.",
                "unauthorized",
              );
            // The API verifies Google's signature, project, expiry and SQL
            // membership on every request. The gateway grants no role.
            return { token };
          }
          if (!session || session.expires <= now()) {
            sessions.delete(sessionId);
            throw new ApiError(
              401,
              "Your session has ended. Sign in again.",
              "session_expired",
            );
          }
          return session;
        };
        const cookie = (id, seconds) =>
          `caregrid_session=${id}; HttpOnly; SameSite=Strict; Path=/api; Max-Age=${seconds}`;
        if (url.pathname === "/api/config" && req.method === "GET")
          return json(200, {
            data: {
              mode: "connected",
              authentication: cloud ? "firebase" : "local-demo-pin",
              campus: cloud?.campus || "Meridian Demo Campus",
              demoEnabled: !cloud,
              ...(cloud ? { firebase: cloud.firebase } : {}),
            },
          });
        if (!cloud && url.pathname === "/api/accounts" && req.method === "GET")
          return json(200, { data: await rpc("account", "demoAccounts") });
        if (
          !cloud &&
          url.pathname === "/api/session" &&
          req.method === "POST"
        ) {
          const address = req.socket.remoteAddress;
          let attempt = attempts.get(address);
          if (!attempt || attempt.reset <= now()) {
            attempt = { count: 0, reset: now() + 60_000 };
            attempts.set(address, attempt);
          }
          if (++attempt.count > 10)
            throw new ApiError(
              429,
              "Too many sign-in attempts. Wait one minute.",
              "rate_limited",
            );
          const { handle, pin } = await readJson(req);
          if (
            typeof handle !== "string" ||
            typeof pin !== "string" ||
            handle.length > 100 ||
            pin.length > 30
          )
            throw new ApiError(400, "Enter a valid account and PIN.");
          const result = await rpc("account", "signIn", { handle, pin });
          if (
            !result?.token ||
            !result.user ||
            !Number.isFinite(Date.parse(result.expiresAt))
          )
            throw new ApiError(502, "Invalid sign-in response.");
          if (session) {
            sessions.delete(sessionId);
            try {
              await rpc("account", "signOut", {}, session.token);
            } catch {
              /* Local session still revoked. */
            }
          }
          const id = randomBytes(32).toString("base64url");
          const expires = Math.min(
            now() + sessionLifetimeMs,
            Date.parse(result.expiresAt),
          );
          sessions.set(id, { token: result.token, expires });
          res.setHeader(
            "Set-Cookie",
            cookie(id, Math.floor((expires - now()) / 1000)),
          );
          return json(200, { data: safeUser(result.user) });
        }
        if (url.pathname === "/api/session" && req.method === "GET")
          return json(200, {
            data: safeUser(
              await rpc("account", "me", {}, authenticated().token),
            ),
          });
        if (url.pathname === "/api/session" && req.method === "DELETE") {
          if (cloud) return json(200, { data: null });
          sessions.delete(sessionId);
          res.setHeader("Set-Cookie", cookie("", 0));
          if (session)
            try {
              await rpc("account", "signOut", {}, session.token);
            } catch {
              /* Always clear the web session. */
            }
          return json(200, { data: null });
        }
        const match = /^\/api\/rpc\/([a-z]+)\/([A-Za-z]+)$/.exec(url.pathname);
        if (
          match &&
          req.method === "POST" &&
          methods.has(`${match[1]}/${match[2]}`)
        ) {
          if (cloud && match[1] === "simulation")
            throw new ApiError(
              404,
              "Demo simulations are disabled in deployment.",
            );
          const current = authenticated();
          const args = await readJson(req);
          if ("method" in args) throw new ApiError(400, "Reserved argument.");
          return json(200, {
            data: await rpc(match[1], match[2], args, current.token),
          });
        }
        throw new ApiError(404, "API action not found.");
      }
      if (!["GET", "HEAD"].includes(req.method))
        throw new ApiError(405, "Method not allowed.");
      const pathname = decodeURIComponent(url.pathname);
      const target = path.resolve(
        root,
        "." + (pathname === "/" ? "/connected.html" : pathname),
      );
      const relative = path.relative(root, target).split(path.sep).join("/");
      if (
        !target.startsWith(root + path.sep) ||
        !types[path.extname(target)] ||
        !(publicFiles.has(relative) || relative.startsWith("assets/"))
      )
        throw new ApiError(404, "Not found.");
      const data = await fs.readFile(target);
      res.writeHead(200, { "Content-Type": types[path.extname(target)] });
      res.end(req.method === "HEAD" ? undefined : data);
    } catch (error) {
      const status =
        error instanceof ApiError
          ? error.status
          : error.code === "ENOENT"
            ? 404
            : 500;
      json(status, {
        error: {
          message:
            error instanceof ApiError
              ? error.message
              : status === 404
                ? "Not found."
                : "The request could not be completed.",
          code: error instanceof ApiError ? error.code : "request_failed",
        },
      });
    }
  });
  return server;
}
if (
  process.argv[1] &&
  path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)
) {
  const port = Number(process.env.PORT || 4173);
  const cloud = cloudConfigFromEnvironment();
  const backendUrl = process.env.CAREGRID_API_URL || "http://127.0.0.1:8080/";
  const server = createCareGridServer({
    backendUrl,
    cloud,
    ...(cloud
      ? { backendHeaders: await googleBackendHeaders(backendUrl) }
      : {}),
  });
  server.on("error", (error) => {
    console.error(error.message);
    process.exitCode = 1;
  });
  server.listen(port, cloud ? "0.0.0.0" : "127.0.0.1", () =>
    console.log(
      cloud
        ? `CareGrid console listening on port ${port}.`
        : `CareGrid connected console: http://127.0.0.1:${port}\nPitch presentation: http://127.0.0.1:${port}/index.html`,
    ),
  );
  for (const signal of ["SIGINT", "SIGTERM"])
    process.on(signal, () => server.close());
}
