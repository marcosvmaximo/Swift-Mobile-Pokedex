import SwiftUI

struct TypeColor {
    static func color(for type: String) -> Color {
        switch type.lowercased() {
        case "grass": return .green
        case "fire": return .red
        case "water": return .blue
        case "electric": return .yellow
        case "psychic": return .purple
        case "poison": return .purple.opacity(0.7)
        case "normal": return .gray
        case "ground": return .brown
        case "flying": return .cyan
        case "fairy": return .pink
        case "bug": return .green.opacity(0.6)
        case "fighting": return .orange
        case "rock": return .brown.opacity(0.7)
        case "steel": return .gray.opacity(0.8)
        case "ice": return .cyan.opacity(0.7)
        case "ghost": return .indigo
        case "dragon": return .indigo.opacity(0.8)
        default: return .black
        }
    }
}
