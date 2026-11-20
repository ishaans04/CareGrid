import { test } from "node:test";
import assert from "node:assert/strict";
import http from "node:http";
import { createCareGridServer } from "../server.mjs";
import { cloudConfigFromEnvironment } from "../cloud-auth.mjs";

const config = cloudConfigFromEnvironment({
  K_SERVICE: "caregrid-web",
  CAREGRID_WEB_ORIGIN: "https://caregrid.example.org",
  FIREBASE_PROJECT_ID: "caregrid-test-project",
  FIREBASE_WEB_API_KEY: "public-test-web-key",
  FIREBASE_WEB_APP_ID: "public-test-app-id",
});
const firebaseToken = "test.header.signature";

async function fixture(t, overrides = {}) {
  const calls = [];
  const server = createCareGridServer({
    cloud: config,
    backendUrl: "https://caregrid-api.example.org/",
    backendHeaders: async () => ({
      "X-Serverless-Authorization": "Bearer GOOGLE-SERVICE-TOKEN",
    }),
    fetchImpl: async (url, init) => {
      calls.push({ url, ...init });
      return Response.json({
        id: 4,
        displayName: "Operator",
        role: "command",
        pin: "hidden",
      });
    },
    ...overrides,
  });
  await new Promise((resolve) => server.listen(0, "127.0.0.1", resolve));
  t.after(
    () =>
      new Promise((resolve) => {
        server.close(resolve);
        server.closeAllConnections();
      }),
  );
  const address = `http://127.0.0.1:${server.address().port}`;
  return {
    calls,
    request: (pathname, method = "GET", headers = {}) =>
      new Promise((resolve, reject) => {
        const req = http.request(
          address + pathname,
          {
            method,
            headers: {
              host: "caregrid.example.org",
              origin: config.origin,
              "x-caregrid-request": "1",
              "content-type": "application/json",
              ...headers,
            },
          },
          (res) => {
            const chunks = [];
            res.on("data", (chunk) => chunks.push(chunk));
            res.on("end", () =>
              resolve(
                new Response(Buffer.concat(chunks), {
                  status: res.statusCode,
                  headers: res.headers,
                }),
              ),
            );
          },
        );
        req.on("error", reject);
        req.end(method === "POST" ? "{}" : undefined);
      }),
  };
}

test("Cloud Run configuration fails closed and exposes only public Firebase fields", async (t) => {
  assert.equal(cloudConfigFromEnvironment({}), null);
  for (const env of [
    { K_SERVICE: "api" },
    { K_SERVICE: "api", CAREGRID_WEB_ORIGIN: "http://localhost" },
  ])
    assert.throws(() => cloudConfigFromEnvironment(env));
  const { request, calls } = await fixture(t);
  const response = await request("/api/config");
  const { data } = await response.json();
  assert.equal(data.authentication, "firebase");
  assert.equal(data.demoEnabled, false);
  assert.equal(data.firebase.projectId, "caregrid-test-project");
  assert.equal(response.headers.get("set-cookie"), null);
  assert.match(
    response.headers.get("content-security-policy"),
    /identitytoolkit.googleapis.com/,
  );
  // Firebase's popup resolver loads the Google API loader from this origin.
  assert.match(
    response.headers.get("content-security-policy"),
    /script-src 'self' https:\/\/apis\.google\.com;/,
  );
  assert.equal(calls.length, 0);
});

test("Firebase bearer and Cloud Run service identity stay in separate headers", async (t) => {
  const { request, calls } = await fixture(t);
  const response = await request("/api/session", "GET", {
    authorization: `Bearer ${firebaseToken}`,
  });
  assert.equal(response.status, 200);
  assert.equal((await response.json()).data.pin, undefined);
  assert.equal(calls[0].headers.Authorization, `Bearer ${firebaseToken}`);
  assert.equal(
    calls[0].headers["X-Serverless-Authorization"],
    "Bearer GOOGLE-SERVICE-TOKEN",
  );
  assert.equal(calls[0].url.origin, "https://caregrid-api.example.org");
  assert.equal(response.headers.get("set-cookie"), null);
});

test("cloud replicas require no in-memory gateway session and ignore local demo cookies", async (t) => {
  const first = await fixture(t);
  const second = await fixture(t);
  for (const { request } of [first, second]) {
    assert.equal(
      (
        await request("/api/session", "GET", {
          authorization: `Bearer ${firebaseToken}`,
        })
      ).status,
      200,
    );
    assert.equal(
      (
        await request("/api/session", "GET", {
          cookie: "caregrid_session=forged",
        })
      ).status,
      401,
    );
  }
});

test("deployed PIN, account listing, simulations and foreign-origin writes are blocked", async (t) => {
  const { request, calls } = await fixture(t);
  assert.equal((await request("/api/accounts")).status, 404);
  assert.equal((await request("/api/session", "POST")).status, 404);
  assert.equal(
    (
      await request("/api/rpc/simulation/start", "POST", {
        authorization: `Bearer ${firebaseToken}`,
      })
    ).status,
    404,
  );
  assert.equal(
    (
      await request("/api/rpc/sos/raise", "POST", {
        origin: "https://evil.example",
        authorization: `Bearer ${firebaseToken}`,
      })
    ).status,
    403,
  );
  assert.equal(
    (await request("/api/session", "GET", { host: "evil.example" })).status,
    403,
  );
  assert.equal(calls.length, 0);
});

test("an IAM token failure cannot fall back to an unauthenticated API call", async (t) => {
  const { request, calls } = await fixture(t, {
    backendHeaders: async () => {
      throw Error("metadata unavailable");
    },
  });
  const response = await request("/api/session", "GET", {
    authorization: `Bearer ${firebaseToken}`,
  });
  assert.equal(response.status, 503);
  assert.equal(calls.length, 0);
  assert.doesNotMatch(
    await response.text(),
    /metadata unavailable|SERVICE-TOKEN/,
  );
});
