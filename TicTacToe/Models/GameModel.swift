import Foundation

enum Player: String, CaseIterable {
    case x = "X"
    case o = "O"

    var opposite: Player {
        self == .x ? .o : .x
    }
}

enum GameOutcome: Equatable {
    case inProgress
    case won(Player)
    case draw
}

@MainActor
final class GameModel: ObservableObject {
    @Published private(set) var board: [Player?] = Array(repeating: nil, count: 9)
    @Published private(set) var currentPlayer: Player = .x
    @Published private(set) var outcome: GameOutcome = .inProgress
    @Published private(set) var scores: [Player: Int] = [.x: 0, .o: 0]
    @Published private(set) var draws: Int = 0

    private static let winningLines: [[Int]] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]
    ]

    var statusMessage: String {
        switch outcome {
        case .inProgress:
            return "\(currentPlayer.rawValue)'s turn"
        case .won(let player):
            return "\(player.rawValue) wins!"
        case .draw:
            return "It's a draw"
        }
    }

    var isGameOver: Bool {
        outcome != .inProgress
    }

    func cellSymbol(at index: Int) -> String? {
        board[index]?.rawValue
    }

    func isCellEnabled(at index: Int) -> Bool {
        board[index] == nil && !isGameOver
    }

    func makeMove(at index: Int) {
        guard isCellEnabled(at: index) else { return }

        board[index] = currentPlayer
        evaluateOutcome()

        if case .inProgress = outcome {
            currentPlayer = currentPlayer.opposite
        }
    }

    func startNewGame() {
        board = Array(repeating: nil, count: 9)
        currentPlayer = .x
        outcome = .inProgress
    }

    func resetScores() {
        scores = [.x: 0, .o: 0]
        draws = 0
        startNewGame()
    }

    private func evaluateOutcome() {
        for line in Self.winningLines {
            let cells = line.map { board[$0] }
            if let first = cells[0], cells.allSatisfy({ $0 == first }) {
                outcome = .won(first)
                scores[first, default: 0] += 1
                return
            }
        }

        if board.allSatisfy({ $0 != nil }) {
            outcome = .draw
            draws += 1
        }
    }
}
