import SwiftUI

struct FavoritoCardView: View {
    @StateObject private var viewModel: FavoritoCardViewModel

    init(favorito: PokemonFavorito) {
        _viewModel = StateObject(wrappedValue: FavoritoCardViewModel(favorito: favorito))
    }

    var body: some View {
        Group {
            if let pokemon = viewModel.pokemonModel {
                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                    PokemonCardView(pokemon: pokemon)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium.rawValue)
                    .fill(DesignSystem.AppColor.surface)
                    .frame(width: 170, height: 200)
                    .overlay(ProgressView())
            }
        }
        .onAppear {
            viewModel.fetchPokemonDetails()
        }
    }
}
