import Foundation
import Combine

final class PokemonService {
    static let shared = PokemonService()
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!

    func fetchPokemon(name: String) -> AnyPublisher<PokemonModel, Error> {
        let url = baseURL.appendingPathComponent(name.lowercased())
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .map { detail in
                let types = detail.types
                    .sorted { $0.slot < $1.slot }
                    .map { $0.type.name.capitalized }
                let imageURL = detail.sprites.frontDefault
                    .flatMap(URL.init(string:))
                return PokemonModel(
                    id: detail.id,
                    name: detail.name.capitalized,
                    types: types,
                    imageURL: imageURL
                )
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
