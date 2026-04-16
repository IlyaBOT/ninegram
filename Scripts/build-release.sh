#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_PATH="${PROJECT_PATH:-$ROOT_DIR/Ninegram.xcodeproj}"
TARGET="${TARGET:-Ninegram}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-$ROOT_DIR/build/DerivedData}"
SDK="${SDK:-iphoneos}"
ALLOW_SIGNING="${ALLOW_SIGNING:-0}"

SIGNING_FLAGS=()
if [[ "$ALLOW_SIGNING" != "1" ]]; then
  SIGNING_FLAGS+=(CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO)
fi

xcodebuild \
  -project "$PROJECT_PATH" \
  -target "$TARGET" \
  -configuration Release \
  -sdk "$SDK" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  "${SIGNING_FLAGS[@]}" \
  build
