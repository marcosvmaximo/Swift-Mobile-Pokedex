import SwiftUI

struct PokemonCardView: View {
    let pokemon: PokemonModel

    var body: some View {
        VStack {
            Group {
                if let url = pokemon.imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                        case .failure(_):
                            Image(systemName: "wifi.exclamationmark")
                                .font(.largeTitle)
                                .foregroundColor(DesignSystem.AppColor.secondary)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.largeTitle)
                        .foregroundColor(DesignSystem.AppColor.secondary)
                }
            }
            .frame(width: 120, height: 120)

            VStack(spacing: DesignSystem.Spacing.small.rawValue) {
                Text("#\(pokemon.id) \(pokemon.name)")
                    .font(DesignSystem.AppFont.headline)
                    .foregroundColor(DesignSystem.AppColor.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                HStack(spacing: DesignSystem.Spacing.xsmall.rawValue) {
                    ForEach(pokemon.types, id: \.self) { typeName in
                        Text(typeName)
                            .font(DesignSystem.AppFont.caption)
                            .foregroundColor(DesignSystem.AppColor.onPrimary)
                            .padding(.horizontal, DesignSystem.Spacing.small.rawValue)
                            .padding(.vertical, DesignSystem.Spacing.xsmall.rawValue)
                            .background(DesignSystem.AppColor.PokemonType.color(for: typeName))
                            .clipShape(Capsule())
                    }
                }
                .frame(height: 20)
            }
            .padding(.horizontal, DesignSystem.Spacing.small.rawValue)
            
            Spacer()
        }
        .padding(.vertical)
        .frame(width: 170, height: 200)
        .background(DesignSystem.AppColor.background)
        .cornerRadius(DesignSystem.CornerRadius.medium.rawValue)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
    }
}
