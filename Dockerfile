# Multi-stage build for minimal Hermes image
# Stage 1: Builder
FROM alpine:latest AS builder

RUN apk add --no-cache \
    bash \
    curl \
    git \
    nodejs \
    npm \
    python3 \
    py3-pip \
    ca-certificates \
    openssh-client \
    jq \
    vim \
    ripgrep \
    ffmpeg

WORKDIR /app

# Install Hermes via official installer
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# Stage 2: Final minimal image
FROM alpine:latest

# Install runtime deps only (no build tools)
RUN apk add --no-cache \
    bash \
    curl \
    git \
    nodejs \
    npm \
    python3 \
    py3-pip \
    ca-certificates \
    openssh-client \
    jq \
    vim \
    ripgrep \
    ffmpeg \
    libstdc++ \
    && rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1000 hermes && \
    adduser -D -u 1000 -G hermes -s /bin/bash hermes

# Copy Hermes installation from builder
COPY --from=builder /usr/local/lib/hermes-agent /usr/local/lib/hermes-agent
COPY --from=builder /usr/local/bin/hermes /usr/local/bin/hermes
COPY --from=builder /root/.local /home/hermes/.local
COPY --from=builder /root/.hermes /home/hermes/.hermes
COPY --from=builder /root/.cache /home/hermes/.cache

# Fix ownership
RUN chown -R hermes:hermes /home/hermes /usr/local/lib/hermes-agent /usr/local/bin/hermes

# Switch to non-root user
USER hermes
WORKDIR /home/hermes

# Environment
ENV HERMES_HOME=/home/hermes/.hermes
ENV PATH="/usr/local/bin:/home/hermes/.local/bin:${PATH}"
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD hermes --version || exit 1

# Keep container running
CMD ["tail", "-f", "/dev/null"]
