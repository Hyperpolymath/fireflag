#!/usr/bin/env bash
# SPDX-License-Identifier: PMPL-1.0-or-later
# Generate FireFlag icons from SVG source

set -euo pipefail

# Create base SVG (will be converted to PNG sizes)
cat > fireflag-base.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <!-- FireFlag icon: flame + flag combination -->
  <!-- Background circle -->
  <circle cx="64" cy="64" r="60" fill="#0060df" opacity="0.1"/>

  <!-- Flag pole -->
  <rect x="38" y="20" width="4" height="88" fill="#0060df"/>

  <!-- Flag with flame shape -->
  <path d="M42 25 Q60 20, 75 30 Q85 35, 85 45 Q85 55, 75 60 Q60 65, 50 60 L42 55 Z"
        fill="#ff9400" stroke="#d70022" stroke-width="1.5"/>

  <!-- Inner flame detail -->
  <path d="M48 35 Q55 30, 62 35 Q68 40, 68 48 Q68 55, 62 58 Q55 60, 50 55 L48 50 Z"
        fill="#ffd700" opacity="0.7"/>

  <!-- Safety badge (green checkmark) -->
  <circle cx="90" cy="90" r="18" fill="#12bc00"/>
  <path d="M84 90 L88 94 L96 84" stroke="white" stroke-width="3"
        fill="none" stroke-linecap="round" stroke-linejoin="round"/>

  <!-- Experimental indicator (orange dot) -->
  <circle cx="75" cy="25" r="6" fill="#ff9400" opacity="0.8"/>
</svg>
EOF

# Generate PNG sizes using ImageMagick or rsvg-convert if available
if command -v rsvg-convert &> /dev/null; then
  for size in 16 32 48 96 128; do
    rsvg-convert -w $size -h $size fireflag-base.svg -o fireflag-${size}.png
  done
  echo "Icons generated using rsvg-convert"
elif command -v convert &> /dev/null; then
  for size in 16 32 48 96 128; do
    convert -background none -density 300 fireflag-base.svg -resize ${size}x${size} fireflag-${size}.png
  done
  echo "Icons generated using ImageMagick"
else
  echo "Warning: Neither rsvg-convert nor ImageMagick found."
  echo "Please install librsvg2-bin or imagemagick to generate PNG icons."
  echo "SVG source saved to fireflag-base.svg"
fi

# Keep SVG for reference
echo "SVG source: fireflag-base.svg"
echo "Icon generation complete!"
