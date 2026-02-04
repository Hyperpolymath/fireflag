#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# Sign FireFlag extension for Mozilla Add-ons submission

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
EXTENSION_DIR="$PROJECT_ROOT/extension"
ARTIFACTS_DIR="$EXTENSION_DIR/web-ext-artifacts"
VERSION="0.1.0"
UNSIGNED_XPI="fireflag-${VERSION}.xpi"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Sign FireFlag extension for Mozilla Add-ons submission.

OPTIONS:
    -k, --api-key KEY       Mozilla API key (required)
    -s, --api-secret SECRET Mozilla API secret (required)
    -c, --channel CHANNEL   Distribution channel: listed or unlisted (default: listed)
    -h, --help              Show this help message

ENVIRONMENT VARIABLES:
    MOZILLA_API_KEY         Alternative to --api-key
    MOZILLA_API_SECRET      Alternative to --api-secret

EXAMPLES:
    # Sign for public listing
    $0 --api-key your_key --api-secret your_secret

    # Sign for self-distribution (unlisted)
    $0 -k your_key -s your_secret -c unlisted

    # Using environment variables
    export MOZILLA_API_KEY=your_key
    export MOZILLA_API_SECRET=your_secret
    $0

GET API CREDENTIALS:
    Visit: https://addons.mozilla.org/developers/addon/api/key/
    Generate API key and secret
    Keep these credentials secret!

EOF
}

error() {
    echo -e "${RED}ERROR: $*${NC}" >&2
    exit 1
}

success() {
    echo -e "${GREEN}✓ $*${NC}"
}

info() {
    echo -e "${YELLOW}ℹ $*${NC}"
}

# Parse arguments
API_KEY="${MOZILLA_API_KEY:-}"
API_SECRET="${MOZILLA_API_SECRET:-}"
CHANNEL="listed"

while [[ $# -gt 0 ]]; do
    case $1 in
        -k|--api-key)
            API_KEY="$2"
            shift 2
            ;;
        -s|--api-secret)
            API_SECRET="$2"
            shift 2
            ;;
        -c|--channel)
            CHANNEL="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            error "Unknown option: $1\nRun '$0 --help' for usage."
            ;;
    esac
done

# Validate inputs
if [[ -z "$API_KEY" ]]; then
    error "Mozilla API key is required. Use --api-key or set MOZILLA_API_KEY environment variable.\nGet credentials at: https://addons.mozilla.org/developers/addon/api/key/"
fi

if [[ -z "$API_SECRET" ]]; then
    error "Mozilla API secret is required. Use --api-secret or set MOZILLA_API_SECRET environment variable.\nGet credentials at: https://addons.mozilla.org/developers/addon/api/key/"
fi

if [[ "$CHANNEL" != "listed" && "$CHANNEL" != "unlisted" ]]; then
    error "Channel must be 'listed' or 'unlisted', got: $CHANNEL"
fi

# Check for unsigned .xpi
if [[ ! -f "$ARTIFACTS_DIR/$UNSIGNED_XPI" ]]; then
    error "Unsigned extension not found at: $ARTIFACTS_DIR/$UNSIGNED_XPI\nRun 'just build-ext' first."
fi

# Check for web-ext
if ! command -v web-ext &> /dev/null; then
    error "web-ext not found. Install with: npm install -g web-ext"
fi

# Print configuration
info "Signing FireFlag v${VERSION}"
echo "  Extension: $ARTIFACTS_DIR/$UNSIGNED_XPI"
echo "  Channel: $CHANNEL"
echo "  API Key: ${API_KEY:0:10}... (hidden)"
echo ""

# Confirm action
if [[ "$CHANNEL" == "listed" ]]; then
    info "This will submit the extension to Mozilla Add-ons for PUBLIC listing."
    info "It will undergo automated and manual review before being published."
else
    info "This will sign the extension for SELF-DISTRIBUTION (unlisted)."
    info "You can distribute the signed .xpi yourself without store listing."
fi

read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Signing cancelled."
    exit 0
fi

# Sign extension
info "Signing extension with Mozilla API..."
cd "$EXTENSION_DIR"

if web-ext sign \
    --api-key="$API_KEY" \
    --api-secret="$API_SECRET" \
    --channel="$CHANNEL" \
    --artifacts-dir="$ARTIFACTS_DIR"; then
    success "Extension signed successfully!"

    # Find signed .xpi
    SIGNED_XPI=$(find "$ARTIFACTS_DIR" -name "fireflag-${VERSION}-an+fx.xpi" -o -name "fireflag-${VERSION}.xpi" | head -1)

    if [[ -n "$SIGNED_XPI" ]]; then
        success "Signed extension: $(basename "$SIGNED_XPI")"

        # Generate checksum
        CHECKSUM=$(sha256sum "$SIGNED_XPI" | awk '{print $1}')
        echo "$CHECKSUM  $(basename "$SIGNED_XPI")" > "$ARTIFACTS_DIR/SHA256SUMS.signed"
        success "Checksum: $CHECKSUM"

        echo ""
        info "Next steps:"
        if [[ "$CHANNEL" == "listed" ]]; then
            echo "  1. Wait for Mozilla automated review (usually minutes)"
            echo "  2. Wait for manual review (1-14 days, typically 3-5 days)"
            echo "  3. Monitor review status at: https://addons.mozilla.org/developers/addons"
            echo "  4. Respond to any reviewer questions promptly"
        else
            echo "  1. Test signed extension: firefox '$SIGNED_XPI'"
            echo "  2. Distribute to users via your website/GitHub"
            echo "  3. Users can install by opening the .xpi file in Firefox"
        fi
    else
        error "Signed .xpi not found in artifacts directory."
    fi
else
    error "Signing failed. Check error messages above."
fi

success "Done!"
