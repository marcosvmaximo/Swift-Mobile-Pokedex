// Pokedex/Resources/DesignSystem.swift

import SwiftUI

enum DesignSystem {
    
    enum AppColor {
        static let primary: Color = .red
        static let secondary: Color = .gray
        static let background: Color = Color(.systemBackground)
        static let surface: Color = Color(.systemGray6)
        static let textPrimary: Color = .primary
        static let textSecondary: Color = .secondary
        static let onPrimary: Color = .white
        
        enum PokemonType {
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
    }
    
    enum AppFont {
        static let largeTitle: Font = .largeTitle.weight(.bold)
        static let title: Font = .title.weight(.bold)
        static let title2: Font = .title2.weight(.bold)
        static let headline: Font = .headline
        static let body: Font = .body
        static let subheadline: Font = .subheadline
        static let caption: Font = .caption
        static let footnote: Font = .footnote
        static let statName: Font = .system(.body, design: .monospaced).weight(.bold)
        static let statValue: Font = .body.weight(.medium)
    }
    
    enum Spacing: CGFloat {
        case xsmall = 4.0
        case small = 8.0
        case medium = 16.0
        case large = 20.0
        case xlarge = 25.0
    }
    
    enum CornerRadius: CGFloat {
        case small = 10.0
        case medium = 12.0
        case large = 20.0
    }
}
