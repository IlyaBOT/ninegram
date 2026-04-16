# Ninegram

Ninegram is a lightweight UIKit-first messaging client shell for legacy iOS devices. The current repo is an MVP app skeleton aimed at iOS 9.3 and iOS 10.0, with an Objective-C UI layer, a mock backend, and clean extension points for a future Telegram backend.

## Current Scope

- Code-based UIKit app shell, no SwiftUI and no large storyboards
- Chats list, chat transcript, and settings screens
- Mock dialogs/messages so the UI is usable offline
- Backend abstraction protocol for a future TDLib or custom MTProto adapter
- Lightweight avatar rendering and memory cache
- iPad-friendly split layout for the chats flow
- Shell scripts and `xcodebuild`-based build/test entry points

## Requirements

- macOS with Xcode and `xcodebuild`
- A toolchain that can still target iOS 9/10 if you need real legacy deployment
- For physical device install: signing configured in Xcode and `ios-deploy` installed

Modern Xcode versions can still open the project, but they no longer help with old armv7 deployment. The source intentionally avoids modern-only APIs so the project remains aligned with older toolchains.

## Quick Start

Open `Ninegram.xcodeproj` in Xcode, configure signing if needed, then build the `Ninegram` scheme.

Command-line entry points:

```bash
make debug
make release
make test
make lint
```

Direct scripts:

```bash
bash ./Scripts/build-debug.sh
bash ./Scripts/build-release.sh
bash ./Scripts/run-tests.sh
bash ./Scripts/lint.sh
bash ./Scripts/install-device.sh
```

## Build Notes

- `build-debug.sh` builds the app for the iOS simulator with code signing disabled.
- `build-release.sh` builds a Release configuration. Signing stays disabled unless `ALLOW_SIGNING=1`.
- `run-tests.sh` runs the XCTest bundle against a simulator destination. Override with `TEST_DESTINATION=...` if your local simulator names differ.
- `install-device.sh` builds for `iphoneos` and pushes the `.app` bundle with `ios-deploy`.
- `.github/workflows/objective-c-xcode.yml` is configured for a `self-hosted` macOS runner with Xcode 13.4.1 because GitHub-hosted images no longer provide `macos-11`/`macos-12`.
- Recommended self-hosted labels for that workflow: `self-hosted`, `macOS`, `legacy-ios`, `xcode-13`.

Example:

```bash
TEST_DESTINATION='platform=iOS Simulator,name=iPhone 8' bash ./Scripts/run-tests.sh
```

## Project Layout

```text
App/                   App delegate, coordinator, build config
UI/                    View controllers, cells, theme, small reusable views
Core/                  Models, service protocols, utilities, caches
Backends/MockBackend/  Offline fake backend used by the MVP shell
Resources/             Info.plist and asset placeholders
Scripts/               xcodebuild wrappers and maintenance scripts
Docs/                  Architecture, roadmap, UI, and performance docs
Tests/                 XCTest coverage for backend behavior
Ninegram.xcodeproj/    Minimal Xcode project
```

## Architecture Summary

- `NGMessagingBackend` is the boundary between the UIKit shell and any real messaging backend.
- `NGServiceContainer` wires the mock backend plus avatar/image cache services.
- `NGAppCoordinator` owns root navigation and the iPad split setup.
- Chats/chat/settings are intentionally thin UIKit controllers with manual layout where it helps scrolling and memory usage.

More detail lives in [Docs/architecture.md](Docs/architecture.md).

## Current Limitations

- No real Telegram authentication or networking
- No persistence layer beyond in-memory mock data
- No attachments, stickers, voice notes, calls, or rich media pipeline
- No search, folders, or background sync
- No production icon set or launch assets yet

## Next Backend Step

Implement a concrete `NGMessagingBackend` adapter that maps a real session layer into the existing dialog/message models:

1. Add an auth/session service for phone login and state restoration.
2. Implement dialog and message fetch/send methods behind `NGMessagingBackend`.
3. Replace mock identifiers with stable backend IDs and add pagination.
4. Introduce SQLite-backed local persistence before enabling large histories.
