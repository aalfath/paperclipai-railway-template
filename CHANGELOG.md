# Changelog

## 2026.1117.0 (2026-11-19)

**Breaking changes (upstream, read before you update):**

- **No way back to 2026.1106.0 without help.** Migration `0415` moves skill package contents out of Postgres into the configured storage (the `/paperclip` volume). Once it has run, an older Paperclip needs that data put back, so take a Postgres backup first if you might roll back.
- The built-in Google Workspace connector is off by default; turn it on under **Settings → Experimental → Google Workspace connector (Paperclip)** if you used it on 2026.1106.0.
- Each subtask gets its own execution workspace, agent-created task trees stop at parent → child, Enter submits replies (Shift+Enter for a new line), and local Codex and OpenCode agents stay warm for 5 minutes. See the [release notes](https://github.com/paperclipai/paperclip/releases/tag/v2026.1117.0) for the full list.

Other:

- Database migrations run automatically at start; companies, agents, tasks and users are kept. No template variables change.
- Image: `ghcr.io/paperclipai/paperclip:2026.1117.0@sha256:bdf38d10544dc6c831e16dc027f23ad586353ef3be1a1b2c6979e63b956aceb1`.

## 2026.1106.0-r1 (2026-11-16)

**Breaking for deployments of the old image-based template:** the template now needs a PostgreSQL database. Paperclip refuses to start in authenticated public mode with its embedded database, which is why deploys of the previous template version crash-looped. Existing projects from the old template don't follow this repo; deploy the template again and move your data if you need to.

- Builds from this repo: `Dockerfile` pins `ghcr.io/paperclipai/paperclip:2026.1106.0@sha256:d6584f05cf57a4b26c117eb083725f18c1fe69ddafa7d16c9f8cce83f6fa17da`.
- Adds a Railway PostgreSQL service and `DATABASE_URL=${{Postgres.DATABASE_URL}}`.
- Sets authenticated public mode, `PAPERCLIP_BIND=lan` and telemetry off in the image.
- Adds generated `PAPERCLIP_AGENT_JWT_SECRET` and `PAPERCLIP_TOOL_ACTION_SIGNING_SECRET`.
- Drops the old `USER_UID`/`USER_GID` workaround: the upstream entrypoint now fixes the ownership of Railway's root-owned volume itself.
- Adds `paperclip-claim`, which prints the first-admin invite (`railway ssh --service Paperclip paperclip-claim`).
