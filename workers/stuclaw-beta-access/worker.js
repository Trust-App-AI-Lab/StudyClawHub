const GITHUB_AUTHORIZE_URL = "https://github.com/login/oauth/authorize";
const GITHUB_TOKEN_URL = "https://github.com/login/oauth/access_token";
const GITHUB_API_URL = "https://api.github.com";
const STATE_MAX_AGE_SECONDS = 10 * 60;

export default {
  async fetch(request, env) {
    try {
      const url = new URL(request.url);
      if (request.method === "OPTIONS") return corsResponse();
      if (url.pathname === "/health") return jsonResponse({ ok: true });
      if (url.pathname === "/github/start") return await startGitHubOAuth(request, env);
      if (url.pathname === "/github/callback") return await finishGitHubOAuth(request, env);
      return jsonResponse({ error: "not_found" }, 404);
    } catch (error) {
      return jsonResponse({ error: "server_error", message: error.message }, 500);
    }
  },
};

async function startGitHubOAuth(request, env) {
  requireEnv(env, ["GITHUB_CLIENT_ID", "SESSION_SECRET", "FRONTEND_URL"]);
  const url = new URL(request.url);
  const returnTo = normalizeReturnTo(url.searchParams.get("return_to"), env);
  const nonce = randomHex(16);
  const state = await createState({ nonce, returnTo, ts: Math.floor(Date.now() / 1000) }, env.SESSION_SECRET);
  const authorize = new URL(GITHUB_AUTHORIZE_URL);
  authorize.searchParams.set("client_id", env.GITHUB_CLIENT_ID);
  authorize.searchParams.set("redirect_uri", callbackUrl(request));
  authorize.searchParams.set("scope", "user:email");
  authorize.searchParams.set("state", state);
  const headers = new Headers({
    Location: authorize.toString(),
    "Set-Cookie": cookie("stuclaw_beta_nonce", nonce, 600),
  });
  return new Response(null, { status: 302, headers });
}

async function finishGitHubOAuth(request, env) {
  requireEnv(env, [
    "GITHUB_CLIENT_ID",
    "GITHUB_CLIENT_SECRET",
    "GITHUB_ADMIN_TOKEN",
    "SESSION_SECRET",
    "TARGET_OWNER",
    "TARGET_REPO",
    "ALLOWED_EMAIL_DOMAINS",
    "FRONTEND_URL",
  ]);

  const url = new URL(request.url);
  const code = url.searchParams.get("code");
  const stateValue = url.searchParams.get("state");
  if (!code || !stateValue) return redirectResult(env.FRONTEND_URL, { status: "error", reason: "missing_code" });

  const state = await verifyState(stateValue, env.SESSION_SECRET);
  if (!state) return redirectResult(env.FRONTEND_URL, { status: "error", reason: "bad_state" });
  const nonce = parseCookies(request.headers.get("Cookie") || "").stuclaw_beta_nonce;
  if (!nonce || nonce !== state.nonce) return redirectResult(state.returnTo, { status: "error", reason: "bad_nonce" });

  const userToken = await exchangeCodeForToken(code, callbackUrl(request), env);
  const user = await githubGet("/user", userToken);
  const emails = await githubGet("/user/emails", userToken);
  const schoolEmail = findAllowedEmail(emails, env.ALLOWED_EMAIL_DOMAINS);
  if (!schoolEmail) return redirectResult(state.returnTo, { status: "blocked", reason: "email_domain" });

  const invite = await inviteCollaborator(user.login, env);
  const fields = {
    status: invite.status === "already" ? "existing" : "approved",
    login: user.login,
  };
  if (invite.inviteUrl) fields.invite_url = invite.inviteUrl;
  return redirectResult(state.returnTo, fields);
}

function callbackUrl(request) {
  const url = new URL(request.url);
  url.pathname = "/github/callback";
  url.search = "";
  return url.toString();
}

function normalizeReturnTo(value, env) {
  const fallback = env.FRONTEND_URL;
  try {
    const candidate = new URL(value || fallback);
    const allowed = new URL(fallback);
    if (candidate.origin !== allowed.origin) return fallback;
    return candidate.toString();
  } catch {
    return fallback;
  }
}

async function exchangeCodeForToken(code, redirectUri, env) {
  const body = new URLSearchParams({
    client_id: env.GITHUB_CLIENT_ID,
    client_secret: env.GITHUB_CLIENT_SECRET,
    code,
    redirect_uri: redirectUri,
  });
  const response = await fetch(GITHUB_TOKEN_URL, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "User-Agent": "StuClaw-Beta-Access",
    },
    body,
  });
  const payload = await response.json();
  if (!response.ok || !payload.access_token) throw new Error(payload.error_description || "GitHub token exchange failed");
  return payload.access_token;
}

async function githubGet(path, token) {
  const response = await fetch(`${GITHUB_API_URL}${path}`, {
    headers: githubHeaders(token),
  });
  const payload = await response.json();
  if (!response.ok) throw new Error(payload.message || `GitHub API ${path} failed`);
  return payload;
}

async function inviteCollaborator(username, env) {
  const path = `/repos/${env.TARGET_OWNER}/${env.TARGET_REPO}/collaborators/${username}`;
  const response = await fetch(`${GITHUB_API_URL}${path}`, {
    method: "PUT",
    headers: {
      ...githubHeaders(env.GITHUB_ADMIN_TOKEN),
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ permission: "pull" }),
  });
  let payload = {};
  try {
    payload = await response.json();
  } catch {}
  if (response.status === 204) return { status: "already" };
  if (response.status === 201) return { status: "invited", inviteUrl: payload.html_url || "" };
  throw new Error(payload.message || "Could not invite collaborator");
}

function githubHeaders(token) {
  return {
    Authorization: `Bearer ${token}`,
    Accept: "application/vnd.github+json",
    "X-GitHub-Api-Version": "2022-11-28",
    "User-Agent": "StuClaw-Beta-Access",
  };
}

function findAllowedEmail(emails, domainsValue) {
  const domains = String(domainsValue || "")
    .split(",")
    .map((domain) => domain.trim().toLowerCase())
    .filter(Boolean);
  return emails.find((entry) => {
    if (!entry || !entry.verified || !entry.email) return false;
    const email = String(entry.email).toLowerCase();
    const domain = email.split("@").pop();
    return domains.some((allowed) => domain === allowed || (allowed.startsWith(".") && domain.endsWith(allowed)));
  });
}

async function createState(payload, secret) {
  const body = base64UrlEncode(JSON.stringify(payload));
  const sig = await hmac(body, secret);
  return `${body}.${sig}`;
}

async function verifyState(value, secret) {
  const [body, sig] = String(value || "").split(".");
  if (!body || !sig) return null;
  const expected = await hmac(body, secret);
  if (sig !== expected) return null;
  let payload;
  try {
    payload = JSON.parse(base64UrlDecode(body));
  } catch {
    return null;
  }
  const now = Math.floor(Date.now() / 1000);
  if (!payload.ts || now - payload.ts > STATE_MAX_AGE_SECONDS) return null;
  return payload;
}

async function hmac(value, secret) {
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(value));
  return base64UrlFromBytes(new Uint8Array(sig));
}

function randomHex(length) {
  const bytes = new Uint8Array(length);
  crypto.getRandomValues(bytes);
  return [...bytes].map((byte) => byte.toString(16).padStart(2, "0")).join("");
}

function base64UrlEncode(value) {
  return btoa(value).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/g, "");
}

function base64UrlDecode(value) {
  const padded = value.replace(/-/g, "+").replace(/_/g, "/").padEnd(Math.ceil(value.length / 4) * 4, "=");
  return atob(padded);
}

function base64UrlFromBytes(bytes) {
  let raw = "";
  for (const byte of bytes) raw += String.fromCharCode(byte);
  return btoa(raw).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/g, "");
}

function parseCookies(header) {
  const out = {};
  for (const part of header.split(";")) {
    const [key, ...rest] = part.trim().split("=");
    if (!key) continue;
    out[key] = decodeURIComponent(rest.join("="));
  }
  return out;
}

function cookie(name, value, maxAge) {
  return `${name}=${encodeURIComponent(value)}; Max-Age=${maxAge}; Path=/github/callback; HttpOnly; Secure; SameSite=Lax`;
}

function redirectResult(returnTo, fields) {
  const url = new URL(returnTo);
  for (const [key, value] of Object.entries(fields)) {
    url.searchParams.set(key, value);
  }
  return Response.redirect(url.toString(), 302);
}

function corsResponse() {
  return new Response(null, {
    status: 204,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET,OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
    },
  });
}

function jsonResponse(payload, status = 200) {
  return new Response(JSON.stringify(payload, null, 2), {
    status,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Access-Control-Allow-Origin": "*",
    },
  });
}

function requireEnv(env, names) {
  const missing = names.filter((name) => !env[name]);
  if (missing.length) throw new Error(`Missing env vars: ${missing.join(", ")}`);
}
