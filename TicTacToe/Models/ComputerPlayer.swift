import Foundation

enum ComputerPlayer {
    private static let winningLines: [[Int]] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]
    ]

    static func bestMove(for board: [Player?], computer: Player) -> Int {
        let human = computer.opposite
        var bestScore = Int.min
        var bestMove = 0

        for index in 0..<9 where board[index] == nil {
            var nextBoard = board
            nextBoard[index] = computer
            let score = minimax(
                board: nextBoard,
                isComputerTurn: false,
                computer: computer,
                human: human
            )
            if score > bestScore {
                bestScore = score
                bestMove = index
            }
        }

        return bestMove
    }

    private static func minimax(
        board: [Player?],
        isComputerTurn: Bool,
        computer: Player,
        human: Player
    ) -> Int {
        switch outcome(for: board) {
        case .won(let winner):
            return winner == computer ? 10 : -10
        case .draw:
            return 0
        case .inProgress:
            break
        }

        var bestScore = isComputerTurn ? Int.min : Int.max

        for index in 0..<9 where board[index] == nil {
            var nextBoard = board
            nextBoard[index] = isComputerTurn ? computer : human
            let score = minimax(
                board: nextBoard,
                isComputerTurn: !isComputerTurn,
                computer: computer,
                human: human
            )
            if isComputerTurn {
                bestScore = max(bestScore, score)
            } else {
                bestScore = min(bestScore, score)
            }
        }

        return bestScore
    }

    private static func outcome(for board: [Player?]) -> GameOutcome {
        for line in winningLines {
            let cells = line.map { board[$0] }
            if let winner = cells[0], cells.allSatisfy({ $0 == winner }) {
                return .won(winner)
            }
        }

        if board.allSatisfy({ $0 != nil }) {
            return .draw
        }

        return .inProgress
    }
}
