# Performance Budget

## Targets

- stay responsive on iPhone 5 and iPad 3 class hardware
- keep scrolling smooth with reuse-only table rendering
- avoid large offscreen render passes and expensive transparency

## UI Rules

- no blur or vibrancy in the MVP shell
- no nested scroll views inside chat cells
- keep message cells to a bubble view and a text label
- keep dialog cells to a small fixed set of subviews
- prefer opaque backgrounds wherever practical

## Memory Rules

- avatar cache: memory-only, small `NSCache`, easy to flush
- transcript rendering: visible text only, no attributed-layout pipeline yet
- no full-history preload strategy for real backends
- section headers are cheap date labels, not separate data-heavy objects

## Data Rules

- dialogs/messages are immutable model objects
- cache computed message heights by message ID and width
- keep service interfaces async so a later backend swap does not rewrite controllers

## Future Budgets

- warm launch under 2 seconds on legacy hardware
- chat open under 150 ms for cached local data
- initial dialog list under 100 visible rows without frame drops
- memory warnings should allow cache eviction without user-visible corruption
