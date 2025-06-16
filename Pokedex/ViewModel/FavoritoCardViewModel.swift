import Foundation
import Combine

class FavoritoCardViewModel: ObservableObject {
    @Published var pokemonModel: PokemonModel?
    
    private var cancellables = Set<AnyCancellable>()
    private let service = PokemonService.shared
    private let favorito: PokemonFavorito

    init(favorito: PokemonFavorito) {
        self.favorito = favorito
    }

    func fetchPokemonDetails() {
        guard pokemonModel == nil, let pokemonName = favorito.nome else { return }

        service.fetchPokemon(name: pokemonName.lowercased())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] fetchedPokemon in
                self?.pokemonModel = fetchedPokemon
            })
            .store(in: &cancellables)
    }
}
