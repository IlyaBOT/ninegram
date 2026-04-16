# Roadmap

## Phase 1: Shell Stabilization

- keep the UIKit shell compiling on legacy-friendly toolchains
- tighten simulator/device build instructions
- add app icons, launch assets, and signing notes
- add simple empty/error states

## Phase 2: Local Data Layer

- introduce SQLite-backed dialog/message storage
- cache normalized peers, dialogs, and message slices
- add boot-time hydration before network refresh
- keep memory bounded with page-based loading

## Phase 3: Real Backend Adapter

- implement auth/session bootstrap
- implement dialog list fetch and updates
- implement message fetch, send, and read state
- add reconnect and request retry strategy

## Phase 4: Usability Features

- pull-to-refresh for dialogs
- unread state transitions
- pinned dialogs
- basic media placeholders for photos/documents

## Explicitly Deferred

- calls
- stories
- secret chats
- stickers engine
- bot web apps
- advanced media composer
