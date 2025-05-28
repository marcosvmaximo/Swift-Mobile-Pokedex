import SwiftUI

struct PokemonRow: View {
    let pokemon: PokemonModel

    var body: some View {
        HStack {
            if let url = pokemon.imageURL {
                AsyncImage(url: url) { img in
                    img.resizable().frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
            }
            VStack(alignment: .leading) {
                Text("#\(pokemon.id) \(pokemon.name)")
                    .font(.headline)
                Text(pokemon.types.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
