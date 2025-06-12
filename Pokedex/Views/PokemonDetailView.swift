import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonModel
    
    // Define a cor principal baseada no primeiro tipo do Pokémon
    private var themeColor: Color {
        TypeColor.color(for: pokemon.types.first?.lowercased() ?? "normal")
    }

    var body: some View {
        ZStack {
            // Fundo dinâmico com a cor do tipo
            themeColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Imagem do Pokémon
                    AsyncImage(url: pokemon.imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 10)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 250)

                    // Cartão de Informações
                    VStack(alignment: .leading, spacing: 25) {
                        // Nome do Pokémon
                        Text(pokemon.name)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.primary)
                        
                        // Tipos do Pokémon (estilo "pílula")
                        HStack {
                            ForEach(pokemon.types, id: \.self) { typeName in
                                Text(typeName)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(TypeColor.color(for: typeName.lowercased()))
                                    .clipShape(Capsule())
                            }
                        }
                        
                        // Divisor
                        Divider()
                        
                        // Seção de Altura e Peso
                        HStack {
                            Spacer()
                            MetricInfoView(title: "Height", value: "\(String(format: "%.1f", pokemon.height)) m")
                            Spacer()
                            MetricInfoView(title: "Weight", value: "\(String(format: "%.1f", pokemon.weight)) kg")
                            Spacer()
                        }
                        
                        // Seção de Estatísticas
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Base Stats")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            // Loop que cria uma StatRowView para cada estatística
                            ForEach(pokemon.stats) { stat in
                                StatRowView(stat: stat, barColor: themeColor)
                            }
                        }
                        
                    }
                    .padding()
                    .background(.background) // Usa a cor de fundo padrão do sistema (branco/preto)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(pokemon.name)
    }
}

// Uma pequena View auxiliar para mostrar Altura e Peso
struct MetricInfoView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    // Exemplo para o Preview
    let samplePokemon = PokemonModel(
        id: 25, name: "Pikachu", types: ["Electric"],
        imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"),
        height: 0.4, weight: 6.0,
        stats: [
            .init(name: "hp", value: 35),
            .init(name: "attack", value: 55),
            .init(name: "defense", value: 40),
            .init(name: "special-attack", value: 50),
            .init(name: "special-defense", value: 50),
            .init(name: "speed", value: 90)
        ]
    )
    return NavigationView {
        PokemonDetailView(pokemon: samplePokemon)
    }
}
