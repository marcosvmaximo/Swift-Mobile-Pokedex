import SwiftUI

struct StatRowView: View {
    let stat: PokemonModel.Stat
    let barColor: Color
    
    // O valor máximo para uma estatística de Pokémon geralmente é 255.
    // Isso nos ajuda a calcular a proporção da barra de progresso.
    private let maxStatValue: Double = 255.0

    var body: some View {
        HStack(spacing: 8) {
            // Nome da estatística abreviado
            Text(stat.abbreviatedName)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.bold)
                .frame(width: 70, alignment: .leading)

            // Valor numérico da estatística
            Text("\(stat.value)")
                .font(.body)
                .fontWeight(.medium)
                .frame(width: 40, alignment: .leading)
            
            // Barra de Progresso
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Fundo da barra
                    Capsule()
                        .frame(width: geometry.size.width, height: 12)
                        .foregroundColor(.gray.opacity(0.2))
                    
                    // Barra de progresso preenchida
                    Capsule()
                        .frame(width: calculateBarWidth(totalWidth: geometry.size.width), height: 12)
                        .foregroundColor(barColor)
                        .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: stat.value)
                }
            }
            .frame(height: 12)
        }
    }
    
    private func calculateBarWidth(totalWidth: CGFloat) -> CGFloat {
        let percentage = CGFloat(stat.value) / CGFloat(maxStatValue)
        return totalWidth * percentage
    }
}

#Preview {
    // Exemplo para o Preview
    let sampleStat = PokemonModel.Stat(name: "special-attack", value: 120)
    return StatRowView(stat: sampleStat, barColor: .red)
        .padding()
}
