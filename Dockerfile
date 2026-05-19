FROM nousresearch/hermes-agent:main

# Find the hermes binary in the official image and ensure it's in PATH.
# The official image installs it under /opt/data/.local/bin or /usr/local/bin,
# but some container exec contexts don't pick it up reliably.
RUN HERMES_BIN=$(find /opt /usr/local /root -maxdepth 4 -name hermes -type f 2>/dev/null | head -1) && \
    if [ -n "$HERMES_BIN" ]; then \
        ln -sf "$HERMES_BIN" /usr/local/bin/hermes; \
        echo "Linked hermes: $HERMES_BIN -> /usr/local/bin/hermes"; \
    else \
        echo "ERROR: hermes binary not found in image"; \
        exit 1; \
    fi

# Also ensure the .local/bin path is available for any uv/python tools
ENV PATH="/opt/data/.local/bin:/usr/local/bin:${PATH}"

# Dokploy-optimized entrypoint
COPY entrypoint.sh /dokploy-entrypoint.sh
RUN chmod +x /dokploy-entrypoint.sh

ENTRYPOINT ["/dokploy-entrypoint.sh"]
CMD []
