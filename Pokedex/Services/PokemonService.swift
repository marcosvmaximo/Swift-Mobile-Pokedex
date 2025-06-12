import Foundation
import Combine

// Adicionado: Structs para decodificar a lista de Pokémon da API
struct PokemonListResponse: Decodable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Decodable {
    let name: String
    let url: String
}

final class PokemonService {
    static let shared = PokemonService()
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!

    // NOVO: Função para buscar a lista de Pokémon com paginação
    func fetchPokemonList(limit: Int, offset: Int) -> AnyPublisher<[PokemonListItem], Error> {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        let url = components.url!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonListResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Função existente para buscar os detalhes de um único Pokémon
    func fetchPokemon(name: String) -> AnyPublisher<PokemonModel, Error> {
        let url = baseURL.appendingPathComponent(name.lowercased())
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .map { detail in
                // Mapeia os tipos
                let types = detail.types
                    .sorted { $0.slot < $1.slot }
                    .map { $0.type.name.capitalized }
                
                // Mapeia a URL da imagem
                let imageURL = detail.sprites.frontDefault
                    .flatMap(URL.init(string:))
                
                // Mapeia as estatísticas
                let stats = detail.stats.map {
                    PokemonModel.Stat(name: $0.stat.name.capitalized, value: $0.baseStat)
                }
                
                // Converte altura (de decímetros para metros) e peso (de hectogramas para kg)
                let heightInMeters = Double(detail.height) / 10.0
                let weightInKg = Double(detail.weight) / 10.0

                // Cria o modelo final para a View
                return PokemonModel(
                    id: detail.id,
                    name: detail.name.capitalized,
                    types: types,
                    imageURL: imageURL,
                    height: heightInMeters,
                    weight: weightInKg,
                    stats: stats
                )
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
