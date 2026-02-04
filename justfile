# SPDX-License-Identifier: AGPL-3.0-or-later
# fireflag - Development Tasks
set shell := ["bash", "-uc"]
set dotenv-load := true

project := "fireflag"

# Show all recipes
default:
    @just --list --unsorted

# Build ReScript sources
build:
    deno run -A npm:rescript build

# Build in watch mode
watch:
    deno run -A npm:rescript build -w

# Clean build artifacts
clean:
    deno run -A npm:rescript clean
    rm -rf src/**/*.res.js src/**/*.bs.js

# Format ReScript code
fmt:
    deno run -A npm:rescript format src/**/*.res

# Type check
check:
    deno run -A npm:rescript build

# Run tests
test:
    deno test --allow-read

# Run example
example:
    deno run --allow-read src/example.js

# Lint (placeholder for future rescript-eslint)
lint:
    @echo "Lint: Type checking via rescript build"
    deno run -A npm:rescript build

# Extension development tasks
# --------------------------

# Build extension icons
icons:
    cd extension/icons && ./generate-icons.sh

# Lint extension with web-ext
lint-ext:
    cd extension && npx web-ext lint --warnings-as-errors

# Build extension .xpi
build-ext:
    cd extension && npx web-ext build --overwrite-dest

# Run extension in Firefox
run-ext:
    cd extension && npx web-ext run --firefox=firefox

# Sign extension for Mozilla Add-ons
sign-ext KEY SECRET:
    cd extension && npx web-ext sign \
        --api-key={{KEY}} \
        --api-secret={{SECRET}} \
        --channel=listed

# Containerization tasks
# -----------------------

# Build in Guix environment
guix-build:
    guix shell -m .containerization/guix-manifest.scm -- \
        bash -c "rescript build && cd extension && npx web-ext build"

# Build with Docker/Podman
container-build:
    podman build -f .containerization/Containerfile -t fireflag:latest .

# Run cerro-terro orchestration
cerro-build:
    @echo "Running cerro-terro build orchestration..."
    @echo "See .containerization/cerro-terro.yml for stages"

# Security scanning tasks
# ------------------------

# Run all security scans
security-scan:
    @echo "Running svalin static analysis..."
    bash -c 'cd .github/workflows && bash svalin-scan.yml'
    @echo "Running vordr verification..."
    bash -c 'cd .github/workflows && bash vordr-verify.yml'
    @echo "Running selur secrets detection..."
    bash -c 'cd .github/workflows && bash selur-secrets.yml'

# Check Idris2 proofs
check-proofs:
    cd extension/lib/idris && idris2 --check FlagSafety.idr
    cd extension/lib/idris && idris2 --check FlagTransaction.idr
    cd extension/lib/idris && idris2 --check SafeUI.idr

# Full build pipeline
# --------------------

# Complete build: proofs -> build -> lint -> security -> package
full-build: check-proofs build icons lint-ext security-scan build-ext
    @echo "✓ Full build complete"
    @ls -lh extension/web-ext-artifacts/
