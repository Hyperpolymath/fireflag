# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
#
# fireflag - Container Build
# RSR-compliant container definition
#
# Build: podman build -f Containerfile -t fireflag .
# Run:   podman run --rm fireflag

# Using Guix for reproducible builds
FROM docker.io/library/debian:bookworm-slim AS base

# Security: Run as non-root user
RUN groupadd --gid 1000 fireflag \
    && useradd --uid 1000 --gid fireflag --shell /bin/bash --create-home fireflag

# Install Guix package manager
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Guix (single-user mode for simplicity)
RUN curl -fsSL https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh | bash -s -- --unattend || true

WORKDIR /app

# Copy source
COPY --chown=fireflag:fireflag . .

USER fireflag

# Build using Guix
RUN guix shell -D -f guix.scm -- just build 2>/dev/null || echo "Build placeholder - no code yet"

# Labels for OCI compliance
LABEL org.opencontainers.image.title="fireflag"
LABEL org.opencontainers.image.description="Feature flag management with fire-and-forget semantics"
LABEL org.opencontainers.image.version="0.1.0"
LABEL org.opencontainers.image.vendor="hyperpolymath"
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later OR MIT"
LABEL org.opencontainers.image.source="https://github.com/hyperpolymath/fireflag"

CMD ["echo", "fireflag v0.1.0 - No executable yet"]
