# Architecture

## Design Goals

- Keep the shell small, readable, and safe for legacy iOS devices.
- Separate backend-facing code from UIKit so the transport layer can be replaced later.
- Prefer manual layout and predictable view hierarchies over deep Auto Layout trees.

## Module Split

### `App/`

- `NGAppDelegate` starts the app.
- `NGAppCoordinator` wires root navigation and chooses phone vs iPad presentation.
- `App/Config/*.xcconfig` keeps build settings readable outside the project file.

### `Core/`

- `Models/` contains immutable dialog and message objects.
- `Services/` defines backend, avatar, cache, and service-container abstractions.
- `Utilities/` contains focused helpers such as date formatting and message height caching.

`Core/` does not depend on view controllers.

### `Backends/MockBackend/`

- Implements `NGMessagingBackend`.
- Keeps dialogs/messages in memory and simulates async completion blocks.
- Acts as the contract reference for a future real backend adapter.

### `UI/`

- `Common/` holds theme and reusable lightweight views.
- `Chats/` owns the dialog list.
- `Chat/` owns transcript rendering and the input bar.
- `Settings/` owns the small grouped settings screen.

UIKit screens consume protocols and models, not backend-specific types.

## Data Flow

1. `NGAppCoordinator` creates `NGServiceContainer`.
2. `NGServiceContainer` exposes `NGMessagingBackend` and avatar services.
3. `NGChatsViewController` fetches dialogs from the backend and displays them.
4. Selecting a dialog creates `NGChatViewController`.
5. `NGChatViewController` fetches/send messages via the same backend protocol.

## Extension Points

### Real backend

Replace `NGMockMessagingBackend` with another `NGMessagingBackend` implementation.

Expected future responsibilities:

- auth/session lifecycle
- dialog pagination
- message pagination
- send/edit/delete mapping
- typing/read state
- disk persistence and sync policy

### Caching

The current avatar cache is in-memory only. A future file-backed cache can implement the same `NGImageCaching` protocol.

### Persistence

The UI layer does not assume how data is stored. A SQLite-backed repository can sit below `NGMessagingBackend` or behind a dedicated storage protocol later.

## iPad Strategy

The chats flow uses `UISplitViewController` on iPad to keep the first release usable without a second visual system. Settings stays as a separate tab to avoid overloading the split master.
