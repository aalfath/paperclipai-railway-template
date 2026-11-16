[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/paperclip-3?utm_medium=integration&utm_source=button&utm_campaign=paperclip)

# Paperclip on Railway

This repo is the source of the [Paperclip Railway template](https://railway.com/deploy/paperclip-3). It runs [Paperclip](https://github.com/paperclipai/paperclip), an open-source control plane for teams of AI agents, as one authenticated web service with a Railway PostgreSQL database.

**Version:** Paperclip `2026.1106.0`, from the official image `ghcr.io/paperclipai/paperclip:2026.1106.0@sha256:d6584f05cf57a4b26c117eb083725f18c1fe69ddafa7d16c9f8cce83f6fa17da`.

## What the template deploys

| Service | Source | Notes |
|---|---|---|
| Paperclip | this repo's `Dockerfile` | Public HTTPS domain on port 3100, health check `/api/health`, volume at `/paperclip` (local secrets key, agent workspaces, backups) |
| Postgres | Railway PostgreSQL | Private network only, volume at `/var/lib/postgresql/data` |

The `Dockerfile` pins the official image and sets authenticated, internet-facing mode (`PAPERCLIP_DEPLOYMENT_MODE=authenticated`, `PAPERCLIP_DEPLOYMENT_EXPOSURE=public`), binds on `0.0.0.0` (`PAPERCLIP_BIND=lan`), and turns telemetry off. It also adds `paperclip-claim`, a helper that prints the first-admin invite.

## Variables

All are set by the template; you don't have to type anything.

| Variable | Value |
|---|---|
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` (private network) |
| `PAPERCLIP_PUBLIC_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` |
| `BETTER_AUTH_SECRET` | generated, 64 hex characters (sessions) |
| `PAPERCLIP_AGENT_JWT_SECRET` | generated, 64 hex characters (agent tokens) |
| `PAPERCLIP_TOOL_ACTION_SIGNING_SECRET` | generated, 64 hex characters (signed tool-action approvals) |
| `PORT` | `3100` |

The image includes the Claude Code, Codex, OpenCode and Gemini CLIs. Connect a provider in Paperclip under **Apps → Connections** (subscription sign-in or an API key), or add a key such as `ANTHROPIC_API_KEY` or `OPENAI_API_KEY` to the Paperclip service yourself.

Keep the generated secrets as they are after the first deploy: changing them signs everyone out and invalidates agent tokens and pending approvals.

## First admin

Public deployments don't show a "Claim this instance" button. After the first deploy is healthy, run this from your machine with the [Railway CLI](https://docs.railway.com/cli) linked to the project:

```sh
railway ssh --service Paperclip paperclip-claim
```

Open the printed invite URL (valid for 72 hours), create your account, and accept the invite. You are then the instance admin. To stop anyone else from signing up afterwards, add the variable `PAPERCLIP_AUTH_DISABLE_SIGN_UP=true` to the Paperclip service.

## Updates

When this repo's `main` branch changes (a new pinned Paperclip version or a wrapper fix), Railway shows an "update available" notice on projects deployed from the template, and you choose when to apply it. Read [CHANGELOG.md](CHANGELOG.md) first. Paperclip runs its database migrations on start, and makes an hourly database backup under `/paperclip`.

## Local test

```sh
docker build -t paperclip-railway .
docker run --rm -p 3100:3100 \
  -e DATABASE_URL=postgres://USER:PASSWORD@HOST:5432/DB \
  -e PAPERCLIP_PUBLIC_URL=http://localhost:3100 \
  -e BETTER_AUTH_SECRET=$(openssl rand -hex 32) \
  -v paperclip-data:/paperclip paperclip-railway
```
