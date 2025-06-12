// Swift-Mobile-Pokedex/Pokedex/ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokemonViewModel()

    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ZStack {
                PokeballBackgroundView()

                VStack(alignment: .leading, spacing: 20) {
                    Text("Pokedex")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    PokedexSearchBar(text: $viewModel.searchText)
                        .padding(.horizontal)

                    ScrollView {
                        LazyVGrid(columns: gridItems, spacing: 16) {
                            ForEach(viewModel.pokemons) { pokemon in
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                    PokemonCardView(pokemon: pokemon)
                                        .onAppear {
                                            // AQUI ESTÁ A MUDANÇA CRUCIAL
                                            // Só busca o próximo lote se não estivermos pesquisando
                                            // e se o Pokémon atual for o último da lista
                                            if !viewModel.isSearching && pokemon.id == viewModel.pokemons.last?.id {
                                                print("Chegou ao final da lista, buscando mais Pokémon...")
                                                viewModel.fetchNextBatchOfPokemons()
                                            }
                                        }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Busca o lote inicial de Pokémon se a lista estiver vazia
                if viewModel.pokemons.isEmpty {
                    viewModel.fetchNextBatchOfPokemons()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
