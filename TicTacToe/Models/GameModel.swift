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
    let humanPlayer: Player = .x
    let computerPlayer: Player = .o

    @Published private(set) var board: [Player?] = Array(repeating: nil, count: 9)
    @Published private(set) var currentPlayer: Player = .x
    @Published private(set) var outcome: GameOutcome = .inProgress
    @Published private(set) var humanWins = 0
    @Published private(set) var computerWins = 0
    @Published private(set) var draws = 0
    @Published private(set) var isComputerThinking = false

    private var computerMoveGeneration = 0

    private static let winningLines: [[Int]] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]
    ]

    var statusMessage: String {
        if isComputerThinking {
            return "Computer is thinking..."
        }

        switch outcome {
        case .inProgress:
            return currentPlayer == humanPlayer ? "Your turn" : "Computer's turn"
        case .won(let player):
            return player == humanPlayer ? "You win!" : "Computer wins!"
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
        board[index] == nil
            && !isGameOver
            && currentPlayer == humanPlayer
            && !isComputerThinking
    }

    func makeMove(at index: Int) {
        guard isCellEnabled(at: index) else { return }

        applyMove(at: index, by: humanPlayer)

        guard case .inProgress = outcome else { return }
        scheduleComputerMove()
    }

    func startNewGame() {
        computerMoveGeneration += 1
        board = Array(repeating: nil, count: 9)
        currentPlayer = humanPlayer
        outcome = .inProgress
        isComputerThinking = false
    }

    func resetScores() {
        humanWins = 0
        computerWins = 0
        draws = 0
        startNewGame()
    }

    private func applyMove(at index: Int, by player: Player) {
        board[index] = player
        evaluateOutcome()

        if case .inProgress = outcome {
            currentPlayer = player.opposite
        }
    }

    private func scheduleComputerMove() {
        isComputerThinking = true
        computerMoveGeneration += 1
        let generation = computerMoveGeneration

        Task {
            try? await Task.sleep(nanoseconds: 450_000_000)
            guard generation == computerMoveGeneration else { return }
            performComputerMove()
        }
    }

    private func performComputerMove() {
        defer { isComputerThinking = false }

        guard case .inProgress = outcome,
              currentPlayer == computerPlayer else { return }

        let move = ComputerPlayer.bestMove(for: board, computer: computerPlayer)
        applyMove(at: move, by: computerPlayer)
    }

    private func evaluateOutcome() {
        for line in Self.winningLines {
            let cells = line.map { board[$0] }
            if let winner = cells[0], cells.allSatisfy({ $0 == winner }) {
                outcome = .won(winner)
                if winner == humanPlayer {
                    humanWins += 1
                } else {
                    computerWins += 1
                }
                return
            }
        }

        if board.allSatisfy({ $0 != nil }) {
            outcome = .draw
            draws += 1
        }
    }
}
