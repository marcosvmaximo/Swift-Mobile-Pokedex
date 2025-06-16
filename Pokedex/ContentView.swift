// Em Pokedex/ContentView.swift
// VERSÃO CORRIGIDA E DEFINITIVA

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
                        .foregroundColor(.red)
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


// --- PONTO CHAVE DA CORREÇÃO FINAL ---
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
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                // A ScrollView agora corta seu conteúdo para evitar vazamento de sombras.
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 16) {
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
                    // O padding agora é mais explícito para garantir espaço no final.
                    .padding(.horizontal)
                    .padding(.bottom, 16) // Espaçamento inferior para a grade.
                    
                    if viewModel.isLoading && !viewModel.pokemons.isEmpty {
                        ProgressView()
                            .padding(.vertical, 20) // Espaçamento para o loader no final.
                    }
                }
                .clipped() // 1. ESTA É A CORREÇÃO PRINCIPAL para o problema visual.
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


#Preview {
    let authViewModel = AuthViewModel()
    let context = CoreDataManager.shared.container.viewContext
    let previewUser = Usuario(context: context)
    previewUser.id = UUID()
    previewUser.email = "preview@user.com"
    authViewModel.usuarioLogado = previewUser
    
    return ContentView()
        .environmentObject(authViewModel)
        .environment(\.managedObjectContext, context)
}
