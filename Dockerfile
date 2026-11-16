# Paperclip for Railway: the official image, pinned by version and digest,
# plus the settings a public Railway deployment needs and a first-admin helper.
FROM ghcr.io/paperclipai/paperclip:2026.1106.0@sha256:d6584f05cf57a4b26c117eb083725f18c1fe69ddafa7d16c9f8cce83f6fa17da

# Authenticated, internet-facing mode. Paperclip then refuses its embedded
# database, so DATABASE_URL must point at Postgres (the template provides it).
# PAPERCLIP_BIND=lan keeps the server on 0.0.0.0 even if a config file on the
# volume says loopback. Telemetry stays off unless the deployer opts in.
ENV PAPERCLIP_DEPLOYMENT_MODE=authenticated \
    PAPERCLIP_DEPLOYMENT_EXPOSURE=public \
    PAPERCLIP_BIND=lan \
    PAPERCLIP_HOME=/paperclip \
    HOST=0.0.0.0 \
    PORT=3100 \
    PAPERCLIP_TELEMETRY_DISABLED=1

COPY --chmod=0755 paperclip-claim /usr/local/bin/paperclip-claim

EXPOSE 3100

# Same start as the upstream image: tini, the upstream entrypoint (fixes the
# ownership of Railway's root-owned volume, then drops to the node user) and
# the server bundle.
ENTRYPOINT ["/usr/bin/tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["node", "server/dist-runtime/index.mjs"]
