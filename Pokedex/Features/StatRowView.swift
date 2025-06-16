import SwiftUI

struct StatRowView: View {
    let stat: PokemonModel.Stat
    let barColor: Color
    
    private let maxStatValue: Double = 255.0

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.small.rawValue) {
            Text(stat.abbreviatedName)
                .font(DesignSystem.AppFont.statName)
                .frame(width: 70, alignment: .leading)

            Text("\(stat.value)")
                .font(DesignSystem.AppFont.statValue)
                .frame(width: 40, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(width: geometry.size.width, height: 12)
                        .foregroundColor(.gray.opacity(0.2))
                    
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
