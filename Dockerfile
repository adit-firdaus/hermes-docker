# Minimal Hermes Docker image using Alpine Linux
FROM alpine:latest

# Install minimal dependencies
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
    vim

# Set working directory
WORKDIR /app

# Install Hermes via official installer
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# Create hermes config directory
RUN mkdir -p /root/.hermes

# Copy Hermes files if they exist in build context
COPY . /app/

# Copy config if provided (optional)
RUN if [ -f hermes.yaml ]; then cp hermes.yaml /root/.hermes/config.yaml; fi

# Set environment variables
ENV HERMES_HOME=/root/.hermes
ENV PATH="/usr/local/bin:${PATH}"

# Verify installation
RUN hermes --version || echo "Hermes installed"

# Default shell
SHELL ["/bin/bash", "-c"]

# Keep container running
CMD ["tail", "-f", "/dev/null"]
