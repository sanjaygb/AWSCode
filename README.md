# Tic Tac Toe (macOS)

A native macOS tic-tac-toe game built with SwiftUI. Play against an unbeatable computer opponent.

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later

## Features

- Single-player mode against a minimax AI (optimal play)
- You play as **X** (blue); the computer plays as **O** (orange)
- Win and draw detection with a running scoreboard
- Native macOS UI with hover feedback and keyboard shortcuts
- **⌘N** — start a new game

## Getting Started

### Option A: Build on your Mac

1. Clone this repository.
2. Open `TicTacToe.xcodeproj` in Xcode.
3. Select the **TicTacToe** scheme and **My Mac** as the run destination.
4. Press **⌘R** to build and run.

Or build from the command line:

```bash
chmod +x scripts/build.sh
./scripts/build.sh
open build/release/TicTacToe.app
```

### Option B: Download a prebuilt app (CI)

Every push to this repo triggers a GitHub Actions build on macOS. Download the latest **`TicTacToe-macOS`** artifact from the [Actions tab](https://github.com/sanjaygb/AWSCode/actions/workflows/build-macos.yml), unzip it, and open `TicTacToe.app`.

> **Note:** CI builds are ad-hoc signed. On first launch, right-click the app → **Open** to bypass Gatekeeper, or allow it in **System Settings → Privacy & Security**.

## Project Structure

```
TicTacToe/
├── TicTacToeApp.swift         # App entry point
├── Models/
│   ├── GameModel.swift        # Game state and turn flow
│   └── ComputerPlayer.swift   # Minimax AI opponent
├── Views/
│   ├── ContentView.swift      # Main window layout
│   ├── BoardView.swift        # 3×3 game grid
│   └── CellView.swift         # Individual cell button
└── Assets.xcassets            # App icon and accent color
```

## How to Play

1. You go first as **X**.
2. Click an empty cell to place your mark.
3. The computer responds automatically after a short pause.
4. Get three in a row — horizontally, vertically, or diagonally — to win.
5. With perfect play on both sides, the game ends in a draw. Use **New Game** to play again, or **Reset Scores** to clear the scoreboard.
