# Base image for all targets
FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=22

WORKDIR /app

# Install runtime packages
COPY --chmod=755 docker/stuff/packages-runtime.sh ./
RUN ./packages-runtime.sh 2>&1 | tee /var/packages-runtime.out

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install wrangler globally for Cloudflare development
RUN npm install -g wrangler

# Create non-root user for development
RUN useradd -ms /bin/bash dev

# Install gosu for proper user switching
RUN apt-get update && apt-get install -y --no-install-recommends \
      gosu \
    && rm -rf /var/lib/apt/lists/*

# Install entrypoint script
COPY --chmod=755 docker/stuff/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]

# ============================================================
# Development target - includes everything needed for interactive development
FROM base AS dev

COPY --chmod=755 docker/stuff/packages-dev.sh ./
RUN ./packages-dev.sh 2>&1 | tee /var/packages-dev.out

CMD ["/bin/bash"]

# ============================================================
# Test target - for running tests
FROM base AS test

CMD ["npm", "test"]

# ============================================================
# Run target - for running the dev server
FROM base AS run

EXPOSE 8787

CMD ["npm", "run", "dev"]

# ============================================================
# Claude target - includes Claude Code CLI for AI-assisted development
FROM dev AS claude

RUN npm install -g @anthropic-ai/claude-code

CMD ["/bin/bash"]
