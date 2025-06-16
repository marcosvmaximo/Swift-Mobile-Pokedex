// Em Pokedex/Services/PokemonService.swift
// VERSÃO CORRIGIDA

import Foundation
import Combine

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
    
    func fetchPokemonList(limit: Int, offset: Int) -> AnyPublisher<[PokemonListItem], Error> {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonListResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemon(name: String) -> AnyPublisher<PokemonModel, Error> {
        let url = baseURL.appendingPathComponent(name.lowercased())
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .tryMap { detail in
                let types = detail.types
                    .sorted(by: { $0.slot < $1.slot })
                    .map { $0.type.name.capitalized }
                
                // --- PONTO CHAVE DA CORREÇÃO ---
                // Agora, tentamos pegar a imagem de alta qualidade primeiro.
                // Se não existir, usamos a imagem pixelada como backup.
                let imageURLString = detail.sprites.other?.officialArtwork.frontDefault ?? detail.sprites.frontDefault ?? ""
                let imageURL = URL(string: imageURLString)
                
                let stats = detail.stats.map {
                    PokemonModel.Stat(name: $0.stat.name, value: $0.baseStat)
                }
                
                let heightInMeters = Double(detail.height) / 10.0
                let weightInKg = Double(detail.weight) / 10.0
                
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
