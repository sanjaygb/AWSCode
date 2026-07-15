#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

CONFIGURATION="${1:-Release}"
DERIVED_DATA="$ROOT_DIR/build/DerivedData"
OUTPUT_DIR="$ROOT_DIR/build/release"

echo "Building TicTacToe ($CONFIGURATION)..."

xcodebuild \
  -project TicTacToe.xcodeproj \
  -scheme TicTacToe \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build

APP_PATH="$(find "$DERIVED_DATA" -name 'TicTacToe.app' -type d | head -1)"
if [ -z "$APP_PATH" ]; then
  echo "error: TicTacToe.app not found after build" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"
rm -rf "$OUTPUT_DIR/TicTacToe.app"
ditto "$APP_PATH" "$OUTPUT_DIR/TicTacToe.app"

echo
echo "Built: $OUTPUT_DIR/TicTacToe.app"
echo "Run with: open \"$OUTPUT_DIR/TicTacToe.app\""
