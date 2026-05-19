FROM nousresearch/hermes-agent:main

# Fix: ensure hermes is available in any terminal session.
# The official image installs to /opt/data/.local/bin but some
# terminal/exec contexts (Dokploy, etc.) don't inherit the full PATH.
RUN if [ -f /opt/data/.local/bin/hermes ] && [ ! -e /usr/local/bin/hermes ]; then \
        ln -s /opt/data/.local/bin/hermes /usr/local/bin/hermes; \
    fi

# Dokploy-optimized entrypoint
COPY entrypoint.sh /dokploy-entrypoint.sh
RUN chmod +x /dokploy-entrypoint.sh

ENTRYPOINT ["/dokploy-entrypoint.sh"]
CMD []
