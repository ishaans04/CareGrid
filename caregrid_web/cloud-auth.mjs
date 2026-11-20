// Google Cloud service identity is separate from the caller's Firebase token.
export function cloudConfigFromEnvironment(env = process.env) {
  if (!env.K_SERVICE) return null;
  const origin = new URL(env.CAREGRID_WEB_ORIGIN || "");
  if (
    origin.protocol !== "https:" ||
    origin.username ||
    origin.password ||
    origin.pathname !== "/" ||
    origin.search ||
    origin.hash
  )
    throw Error("CAREGRID_WEB_ORIGIN must be the exact HTTPS console origin.");
  const projectId = env.FIREBASE_PROJECT_ID;
  if (!/^[a-z][a-z0-9-]{4,28}[a-z0-9]$/.test(projectId || ""))
    throw Error("Set FIREBASE_PROJECT_ID.");
  if (!env.FIREBASE_WEB_API_KEY || !env.FIREBASE_WEB_APP_ID)
    throw Error("Set the public Firebase web API key and app ID.");
  return {
    origin: origin.origin,
    campus: env.CAREGRID_CAMPUS_LABEL || "Meridian Demo Campus",
    firebase: {
      projectId,
      apiKey: env.FIREBASE_WEB_API_KEY,
      appId: env.FIREBASE_WEB_APP_ID,
      authDomain: `${projectId}.firebaseapp.com`,
    },
  };
}

export async function googleBackendHeaders(backendUrl) {
  const target = new URL(backendUrl);
  if (
    target.protocol !== "https:" ||
    target.username ||
    target.password ||
    target.pathname !== "/" ||
    target.search ||
    target.hash
  )
    throw Error("The deployed CareGrid API must have a fixed HTTPS origin.");
  const { GoogleAuth } = await import("google-auth-library");
  const auth = new GoogleAuth();
  let client;
  return async () => {
    client ??= await auth.getIdTokenClient(target.origin);
    const headers = await client.getRequestHeaders();
    const authorization = headers.get("authorization");
    if (!authorization?.startsWith("Bearer "))
      throw Error("Missing Google service identity.");
    return { "X-Serverless-Authorization": authorization };
  };
}
