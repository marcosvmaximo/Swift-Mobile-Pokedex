// Em Pokedex/Views/FavoritoView.swift

import SwiftUI
import CoreData

struct FavoritosView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @FetchRequest var favoritos: FetchedResults<PokemonFavorito>
    
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    init(usuario: Usuario) {
        _favoritos = FetchRequest<PokemonFavorito>(
            sortDescriptors: [NSSortDescriptor(keyPath: \PokemonFavorito.pokemonID, ascending: true)],
            predicate: NSPredicate(format: "usuario == %@", usuario)
        )
    }

    var body: some View {
        // A NavigationView que existia aqui foi REMOVIDA.
        ZStack {
            PokeballBackgroundView()
            if favoritos.isEmpty {
                Text("Você ainda não tem Pokémon favoritos.")
                    .font(.headline).foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 16) {
                        ForEach(favoritos) { favorito in
                            let pokemonModel = PokemonModel(
                                id: Int(favorito.pokemonID),
                                name: favorito.nome ?? "Desconhecido",
                                types: (favorito.tipos ?? "").components(separatedBy: ","),
                                imageURL: URL(string: favorito.imagemUrl ?? ""),
                                height: 0, weight: 0, stats: []
                            )
                            NavigationLink(destination: PokemonDetailView(pokemon: pokemonModel)) {
                                 PokemonCardView(pokemon: pokemonModel)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        // Os modificadores .navigationTitle e .toolbar foram REMOVIDOS daqui.
    }
}
