import SwiftUI

struct BoardView: View {
    @ObservedObject var game: GameModel

    private let columns = Array(repeating: GridItem(.fixed(96), spacing: 12), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<9, id: \.self) { index in
                CellView(
                    symbol: game.cellSymbol(at: index),
                    isEnabled: game.isCellEnabled(at: index)
                ) {
                    game.makeMove(at: index)
                }
            }
        }
        .padding(4)
    }
}
