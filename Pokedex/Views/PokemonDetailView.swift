// Em Pokedex/Views/PokemonDetailView.swift
// VERSÃO CORRIGIDA

import SwiftUI
import Combine // NOVO: Importar Combine para usar publicadores e o Set de 'cancellables'

struct PokemonDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // ALTERAÇÃO: A propriedade 'pokemon' agora é um @State para que possa ser
    // atualizada pela própria view após buscar os dados completos da rede.
    @State var pokemon: PokemonModel
    
    // NOVO: Um estado para controlar a exibição do indicador de carregamento.
    @State private var isLoading = false
    
    // NOVO: Um Set para armazenar a inscrição da chamada de rede, garantindo que
    // ela seja cancelada quando a view for removida da tela.
    @State private var cancellables = Set<AnyCancellable>()
    
    private var themeColor: Color {
        TypeColor.color(for: pokemon.types.first?.lowercased() ?? "normal")
    }

    var body: some View {
        ZStack {
            themeColor.ignoresSafeArea()
            
            // NOVO: Lógica que exibe um indicador de carregamento se 'isLoading' for verdadeiro.
            // Caso contrário, mostra o conteúdo principal da view.
            if isLoading {
                ProgressView("Carregando Detalhes...")
                    .tint(.white) // Melhora a visibilidade no fundo colorido
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        AsyncImage(url: pokemon.imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .shadow(radius: 10)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 250)

                        VStack(alignment: .leading, spacing: 25) {
                            HStack {
                                Text(pokemon.name)
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Button(action: {
                                    authViewModel.alternarFavorito(pokemon: pokemon)
                                }) {
                                    Image(systemName: authViewModel.ehFavorito(pokemon: pokemon) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.title)
                                }
                            }
                            
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
                            
                            Divider()
                            
                            HStack {
                                Spacer()
                                MetricInfoView(title: "Height", value: "\(String(format: "%.1f", pokemon.height)) m")
                                Spacer()
                                MetricInfoView(title: "Weight", value: "\(String(format: "%.1f", pokemon.weight)) kg")
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Base Stats")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                ForEach(pokemon.stats) { stat in
                                    StatRowView(stat: stat, barColor: themeColor)
                                }
                            }
                        }
                        .padding()
                        .background(.background)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(pokemon.name)
        // NOVO: Dispara a função 'loadFullPokemonData' quando a view aparece na tela.
        .onAppear(perform: loadFullPokemonData)
    }

    // NOVO: Função para buscar os dados completos do Pokémon na API.
    private func loadFullPokemonData() {
        // A função só executa se os dados estiverem incompletos.
        // Verificamos se 'stats' está vazio, pois é um dado que não vem do Core Data.
        guard pokemon.stats.isEmpty else {
            return
        }
        
        isLoading = true
        
        // Usa o PokemonService para buscar os detalhes completos.
        PokemonService.shared.fetchPokemon(name: pokemon.name.lowercased())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                isLoading = false // Para o indicador de carregamento
                if case .failure(let error) = completion {
                    print("Erro ao carregar detalhes do favorito: \(error.localizedDescription)")
                }
            }, receiveValue: { fullPokemon in
                // A mágica acontece aqui: o @State 'pokemon' é atualizado com o
                // modelo completo, e a view se redesenha com os novos dados.
                self.pokemon = fullPokemon
            })
            .store(in: &cancellables)
    }
}

struct MetricInfoView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title).font(.subheadline).fontWeight(.bold).foregroundColor(.secondary)
            Text(value).font(.headline).fontWeight(.medium)
        }
    }
}

// O Preview não precisa de alterações, ele já funciona como estava.
#Preview {
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
            .environmentObject(AuthViewModel())
    }
}
