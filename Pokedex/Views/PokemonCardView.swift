import SwiftUI

struct PokemonCardView: View {
    let pokemon: PokemonModel

    var body: some View {
        VStack {
            // --- ÁREA DA IMAGEM ATUALIZADA ---
            Group {
                // Primeiro, verificamos se a URL existe
                if let url = pokemon.imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                        case .failure(_):
                            // A URL existe, mas o download falhou
                            Image(systemName: "wifi.exclamationmark")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        case .empty:
                            // Carregando a imagem
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    // A API não forneceu uma URL para a imagem
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 120, height: 120)

            // Informações do Pokémon
            VStack(spacing: 8) {
                Text("#\(pokemon.id) \(pokemon.name)")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                HStack(spacing: 4) {
                    ForEach(pokemon.types, id: \.self) { typeName in
                        Text(typeName)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(TypeColor.color(for: typeName))
                            .clipShape(Capsule())
                    }
                }
                .frame(height: 20)
            }
            .padding(.horizontal, 10)
            
            Spacer()
        }
        .padding(.vertical)
        .frame(width: 170, height: 200)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
    }
}
