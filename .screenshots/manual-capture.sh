#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# Manual screenshot capture helper

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/store"

mkdir -p "$OUTPUT_DIR"

echo "FireFlag Manual Screenshot Capture"
echo "==================================="
echo ""
echo "This script will help you capture screenshots of the running extension."
echo "Firefox should already be running with FireFlag loaded."
echo ""
echo "Output directory: $OUTPUT_DIR"
echo ""

capture_screenshot() {
    local name="$1"
    local description="$2"
    local output="$OUTPUT_DIR/${name}.png"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📸 Screenshot: $name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "$description"
    echo ""
    echo "Instructions:"
    echo "1. Set up the view in Firefox as described above"
    echo "2. Press ENTER when ready"
    echo "3. Click on the window/area to capture"
    echo ""
    read -p "Press ENTER to capture, or 's' to skip... " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo "⏭️  Skipped"
        echo ""
        return
    fi

    echo "Click on the window or drag to select area..."
    import "$output"

    if [ -f "$output" ]; then
        echo "✅ Captured: $output"
        echo "   Size: $(du -h "$output" | cut -f1)"
        echo ""
    else
        echo "❌ Capture failed"
        echo ""
    fi
}

echo "Make sure Firefox is running with FireFlag extension loaded!"
echo ""
read -p "Is Firefox running? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please start Firefox first:"
    echo "  cd extension && npx web-ext run"
    exit 1
fi

echo ""
echo "Starting screenshot capture..."
echo ""
sleep 1

# Screenshot 1: Popup Overview
capture_screenshot "01-popup-overview" \
"SETUP: Click the FireFlag icon in toolbar
- Popup should open showing categories
- Make sure 'All Categories' or 'Privacy' is selected
- Search box empty
- Shows several flags

CAPTURE: Click on the popup window (400x600 area)"

# Screenshot 2: Flag Details
capture_screenshot "02-popup-flag-detail" \
"SETUP: In the popup, click on a flag (e.g., privacy.resistFingerprinting)
- Details panel should show on right side
- Shows: name, description, safety level, current value, effects
- 'Apply' button visible

CAPTURE: Click on the popup with details showing"

# Screenshot 3: Sidebar Flags Tab
capture_screenshot "03-sidebar-flags" \
"SETUP: Open sidebar (View menu → Sidebars → FireFlag, or Ctrl+Shift+Y)
- 'Flags' tab should be active
- Shows list of modified flags (if none, modify one first)
- Each entry shows: name, before/after values, timestamp

CAPTURE: Click on the sidebar panel (350x700 area)"

# Screenshot 4: Sidebar History Tab
capture_screenshot "04-sidebar-history" \
"SETUP: In sidebar, click 'History' tab
- Shows chronological list of changes
- Each entry: flag name, old→new value, timestamp, reason
- Export buttons visible at bottom

CAPTURE: Click on the sidebar panel showing history"

# Screenshot 5: Options Page
capture_screenshot "05-options" \
"SETUP: Right-click FireFlag icon → Manage Extension → Options
OR: about:addons → FireFlag → Options
- Options page should be open
- Shows: Auto-update toggle, update frequency, notifications
- Permissions section visible
- Clear data button visible

CAPTURE: Click anywhere on the options page (full browser window)"

# Screenshot 6: DevTools Panel
capture_screenshot "06-devtools" \
"SETUP: Press F12 to open DevTools
- Click on 'FireFlag' tab in DevTools
- Should show active flags for current page
- Performance impact indicators
- Flag recommendations (if any)

CAPTURE: Click on the DevTools panel area (1280x400)"

# Screenshot 7: Permission Dialog
capture_screenshot "07-permission-dialog" \
"SETUP: In popup, try to toggle a flag you haven't granted permission for
- Permission request dialog should appear
- Shows: permission name, what it allows, Allow/Deny buttons
- FireFlag branding visible

CAPTURE: Click on the permission dialog (400x300 area)
NOTE: This is tricky - capture quickly before granting/denying!"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Screenshot capture complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Output directory: $OUTPUT_DIR"
echo ""

# List captured screenshots
if ls "$OUTPUT_DIR"/*.png 1> /dev/null 2>&1; then
    echo "Captured screenshots:"
    ls -lh "$OUTPUT_DIR"/*.png | awk '{print "  " $9 " (" $5 ")"}'
    echo ""
    echo "Total screenshots: $(ls "$OUTPUT_DIR"/*.png | wc -l)"
else
    echo "No screenshots captured."
fi

echo ""
echo "Next steps:"
echo "1. Review screenshots in $OUTPUT_DIR"
echo "2. Retake any that didn't turn out well"
echo "3. Optimize with: just optimize-screenshots"
echo "4. Add to Mozilla submission"
