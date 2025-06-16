import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if let usuario = authViewModel.usuarioLogado {
            NavigationView {
                TabView {
                    PokedexPrincipalView()
                        .tabItem {
                            Label("Pokedex", systemImage: "list.bullet")
                        }
                    
                    FavoritosView(usuario: usuario)
                        .tabItem {
                            Label("Favoritos", systemImage: "star.fill")
                        }
                }
                .navigationTitle("Pokedex")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            authViewModel.logout()
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                        .foregroundColor(DesignSystem.AppColor.primary)
                    }
                }
            }
            .environmentObject(authViewModel)
        } else {
            LoginView()
                .environmentObject(authViewModel)
        }
    }
}

struct PokedexPrincipalView: View {
    @StateObject private var viewModel = PokemonViewModel()
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            PokedexSearchBar(text: $viewModel.searchText)
                .padding()

            if viewModel.isLoading && viewModel.pokemons.isEmpty {
                Spacer()
                ProgressView("Carregando...")
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                Text(errorMessage)
                    .foregroundColor(DesignSystem.AppColor.primary)
                    .padding()
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: DesignSystem.Spacing.medium.rawValue) {
                        ForEach(viewModel.pokemons) { pokemon in
                            NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                PokemonCardView(pokemon: pokemon)
                                    .onAppear {
                                        if !viewModel.isSearching && pokemon.id == viewModel.pokemons.last?.id {
                                            viewModel.fetchNextBatchOfPokemons()
                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, DesignSystem.Spacing.medium.rawValue)
                    
                    if viewModel.isLoading && !viewModel.pokemons.isEmpty {
                        ProgressView()
                            .padding(.vertical, DesignSystem.Spacing.large.rawValue)
                    }
                }
                .clipped()
            }
        }
        .background(PokeballBackgroundView())
        .onAppear {
            if viewModel.pokemons.isEmpty {
                viewModel.fetchNextBatchOfPokemons()
            }
        }
    }
}
