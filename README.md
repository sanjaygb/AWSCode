# Tic Tac Toe (macOS)

A native macOS tic-tac-toe game built with SwiftUI.

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later

## Features

- Two-player local gameplay (X and O alternate turns)
- Win and draw detection
- Running scoreboard with reset
- Native macOS UI with hover feedback and keyboard shortcuts
- **⌘N** — start a new game

## Getting Started

1. Clone this repository.
2. Open `TicTacToe.xcodeproj` in Xcode.
3. Select the **TicTacToe** scheme and **My Mac** as the run destination.
4. Press **⌘R** to build and run.

## Project Structure

```
TicTacToe/
├── TicTacToeApp.swift      # App entry point
├── Models/
│   └── GameModel.swift     # Game state and logic
├── Views/
│   ├── ContentView.swift   # Main window layout
│   ├── BoardView.swift     # 3×3 game grid
│   └── CellView.swift      # Individual cell button
└── Assets.xcassets         # App icon and accent color
```

## How to Play

1. Player **X** goes first (blue).
2. Click an empty cell to place your mark.
3. Get three in a row — horizontally, vertically, or diagonally — to win.
4. Use **New Game** to play again, or **Reset Scores** to clear the scoreboard.
