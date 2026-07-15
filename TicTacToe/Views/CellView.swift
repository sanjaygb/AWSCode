import SwiftUI

struct CellView: View {
    let symbol: String?
    let isEnabled: Bool
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(cellBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.primary.opacity(0.12), lineWidth: 1)
                    }

                if let symbol {
                    Text(symbol)
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(symbol == "X" ? Color.blue : Color.orange)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(width: 96, height: 96)
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .onHover { hovering in
            isHovered = hovering && isEnabled
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: symbol)
    }

    private var cellBackground: Color {
        if isHovered {
            return Color.accentColor.opacity(0.12)
        }
        return Color(nsColor: .controlBackgroundColor)
    }
}
