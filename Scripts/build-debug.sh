#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_PATH="${PROJECT_PATH:-$ROOT_DIR/Ninegram.xcodeproj}"
TARGET="${TARGET:-Ninegram}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-$ROOT_DIR/build/DerivedData}"
SDK="${SDK:-iphonesimulator}"

xcodebuild \
  -project "$PROJECT_PATH" \
  -target "$TARGET" \
  -configuration Debug \
  -sdk "$SDK" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  build
