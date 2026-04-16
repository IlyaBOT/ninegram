#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_PATH="${PROJECT_PATH:-$ROOT_DIR/Ninegram.xcodeproj}"
TARGET="${TARGET:-Ninegram}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-$ROOT_DIR/build/DerivedData}"
CONFIGURATION="${CONFIGURATION:-Debug}"

if ! command -v ios-deploy >/dev/null 2>&1; then
  echo "ios-deploy is required for device installation." >&2
  exit 1
fi

xcodebuild \
  -project "$PROJECT_PATH" \
  -target "$TARGET" \
  -configuration "$CONFIGURATION" \
  -sdk iphoneos \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  build

APP_BUNDLE_PATH="$DERIVED_DATA_PATH/Build/Products/${CONFIGURATION}-iphoneos/Ninegram.app"

if [[ ! -d "$APP_BUNDLE_PATH" ]]; then
  echo "Built app bundle not found at $APP_BUNDLE_PATH" >&2
  exit 1
fi

if [[ -n "${DEVICE_ID:-}" ]]; then
  ios-deploy --id "$DEVICE_ID" --bundle "$APP_BUNDLE_PATH"
else
  ios-deploy --bundle "$APP_BUNDLE_PATH"
fi
