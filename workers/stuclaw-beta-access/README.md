# StuClaw Beta Access Worker

This Cloudflare Worker backs the hidden StudyClawHub beta page at
`site/stuclaw-beta.html`.

It performs the private part of the flow:

1. Start GitHub OAuth with `user:email`.
2. Read the authenticated user's verified GitHub emails.
3. Require an email domain from `ALLOWED_EMAIL_DOMAINS`; each configured domain
   allows both the exact domain and its subdomains, so `hkust-gz.edu.cn` also
   allows `connect.hkust-gz.edu.cn`.
4. Invite the GitHub user to `Trust-App-AI-Lab/stuclaw-desktop` with `pull`
   permission.
5. Redirect the browser back to the beta page with a result status.

## GitHub Setup

Create a GitHub OAuth App:

- Homepage URL: `https://trust-app-ai-lab.github.io/StudyClawHub/stuclaw-beta.html`
- Authorization callback URL: `https://<worker-host>/github/callback`

Create a fine-grained GitHub token for the target repository with enough
permission to manage collaborators. Prefer limiting it to only
`Trust-App-AI-Lab/stuclaw-desktop`.

## Cloudflare Setup

Copy the example config:

```bash
cp wrangler.toml.example wrangler.toml
```

Set secrets:

```bash
wrangler secret put GITHUB_CLIENT_ID
wrangler secret put GITHUB_CLIENT_SECRET
wrangler secret put GITHUB_ADMIN_TOKEN
wrangler secret put SESSION_SECRET
```

Deploy:

```bash
wrangler deploy
```

After deployment, set `window.STUCLAW_BETA.apiBase` in
`site/stuclaw-beta.html` to the Worker URL.
