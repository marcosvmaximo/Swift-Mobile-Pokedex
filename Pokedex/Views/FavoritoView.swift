import SwiftUI
import CoreData

struct FavoritosView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @FetchRequest var favoritos: FetchedResults<PokemonFavorito>
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private var gridItems: [GridItem] {
        let columnCount = horizontalSizeClass == .compact ? 2 : 4
        return Array(repeating: .init(.flexible()), count: columnCount)
    }

    init(usuario: Usuario) {
        _favoritos = FetchRequest<PokemonFavorito>(
            sortDescriptors: [NSSortDescriptor(keyPath: \PokemonFavorito.pokemonID, ascending: true)],
            predicate: NSPredicate(format: "usuario == %@", usuario)
        )
    }

    var body: some View {
        ZStack {
            PokeballBackgroundView()
            if favoritos.isEmpty {
                Text("Você ainda não tem Pokémon favoritos.")
                    .font(DesignSystem.AppFont.headline)
                    .foregroundColor(DesignSystem.AppColor.secondary)
            } else {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: DesignSystem.Spacing.medium.rawValue) {
                        ForEach(favoritos) { favorito in
                            FavoritoCardView(favorito: favorito)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
