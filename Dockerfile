FROM nousresearch/hermes-agent:main

# Install Chromium + Playwright browser for tool automation
RUN if command -v apt-get >/dev/null 2>&1; then \
        apt-get update && apt-get install -y --no-install-recommends \
            chromium fonts-liberation libasound2 libatk-bridge2.0-0 \
            libatk1.0-0 libcups2 libdrm2 libgbm1 libgtk-3-0 \
            libnspr4 libnss3 libxcomposite1 libxdamage1 \
            libxfixes3 libxrandr2 xdg-utils \
            && rm -rf /var/lib/apt/lists/*; \
    elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache chromium chromium-chromedriver; \
    fi

# Install Playwright Chromium browser binary (~150MB)
RUN npx playwright install chromium 2>/dev/null || true

# Find and link hermes binary so it's available in any terminal session
RUN HERMES_BIN=$(find /opt /usr/local /root -maxdepth 4 -name hermes -type f 2>/dev/null | head -1) && \
    if [ -n "$HERMES_BIN" ]; then \
        ln -sf "$HERMES_BIN" /usr/local/bin/hermes; \
    fi

ENV PATH="/opt/data/.local/bin:/usr/local/bin:${PATH}"

# Dokploy-optimized entrypoint
COPY entrypoint.sh /dokploy-entrypoint.sh
RUN chmod +x /dokploy-entrypoint.sh

ENTRYPOINT ["/dokploy-entrypoint.sh"]
CMD []
