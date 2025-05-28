//
//  ContentView.swift
//  Pokedex
//
//  Created by Marcos Máximo on 27/05/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokemonViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.red
                    .ignoresSafeArea()

                VStack {
                    // Detalhe Pokedex
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 60, height: 60)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                    }
                    Spacer()

                    // Campo de busca ligado ao ViewModel
                    TextField("Digite o nome do Pokémon", text: $viewModel.searchText)
                        .padding(22)
                        .background(Color.white)
                        .cornerRadius(25)
                        .frame(maxWidth: 330)

                    // Resultados
                    if !viewModel.pokemons.isEmpty {
                        List(viewModel.pokemons) { pokemon in
                            PokemonRow(pokemon: pokemon)
                        }
                        .listStyle(.plain)
                        .background(Color.white)
                        .frame(maxHeight: 400)
                        .frame(maxWidth: 330)
                        .cornerRadius(25)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Pokedex")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                viewModel.fetchRandomPokemons()
            }
        }
    }
}

#Preview {
    ContentView()
}
