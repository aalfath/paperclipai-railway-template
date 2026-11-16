# Changelog

## 2026.1106.0-r1 (2026-11-16)

**Breaking for deployments of the old image-based template:** the template now needs a PostgreSQL database. Paperclip refuses to start in authenticated public mode with its embedded database, which is why deploys of the previous template version crash-looped. Existing projects from the old template don't follow this repo; deploy the template again and move your data if you need to.

- Builds from this repo: `Dockerfile` pins `ghcr.io/paperclipai/paperclip:2026.1106.0@sha256:d6584f05cf57a4b26c117eb083725f18c1fe69ddafa7d16c9f8cce83f6fa17da`.
- Adds a Railway PostgreSQL service and `DATABASE_URL=${{Postgres.DATABASE_URL}}`.
- Sets authenticated public mode, `PAPERCLIP_BIND=lan` and telemetry off in the image.
- Adds generated `PAPERCLIP_AGENT_JWT_SECRET` and `PAPERCLIP_TOOL_ACTION_SIGNING_SECRET`.
- Drops the old `USER_UID`/`USER_GID` workaround: the upstream entrypoint now fixes the ownership of Railway's root-owned volume itself.
- Adds `paperclip-claim`, which prints the first-admin invite (`railway ssh --service Paperclip paperclip-claim`).
