import SwiftUI

struct ContentView: View {
    @StateObject private var game = GameModel()

    var body: some View {
        VStack(spacing: 24) {
            header
            BoardView(game: game)
            footer
        }
        .padding(32)
        .frame(minWidth: 420, minHeight: 520)
        .background(Color(nsColor: .windowBackgroundColor))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("New Game") {
                    game.startNewGame()
                }
                .keyboardShortcut("n", modifiers: .command)

                Button("Reset Scores") {
                    game.resetScores()
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Tic Tac Toe")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text(game.statusMessage)
                .font(.title3.weight(.medium))
                .foregroundStyle(statusColor)
                .animation(.easeInOut(duration: 0.2), value: game.statusMessage)
        }
    }

    private var footer: some View {
        HStack(spacing: 24) {
            scoreBadge(title: "X", value: game.scores[.x, default: 0], color: .blue)
            scoreBadge(title: "Draws", value: game.draws, color: .secondary)
            scoreBadge(title: "O", value: game.scores[.o, default: 0], color: .orange)
        }
        .font(.headline)
    }

    private func scoreBadge(title: String, value: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .foregroundStyle(color)
            Text("\(value)")
                .font(.title2.monospacedDigit())
        }
        .frame(minWidth: 72)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
        }
    }

    private var statusColor: Color {
        switch game.outcome {
        case .inProgress:
            return game.currentPlayer == .x ? .blue : .orange
        case .won(let player):
            return player == .x ? .blue : .orange
        case .draw:
            return .secondary
        }
    }
}

#Preview {
    ContentView()
}
