//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Marcos Máximo on 27/05/25.
//

import Foundation
import Combine
final class PokemonViewModel: ObservableObject {
    @Published var pokemons: [PokemonModel] = []
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    private let service = PokemonService.shared

    init() {
        $searchText
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] term in
                let trimmed = term.trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty {
                    self?.pokemons = []
                } else {
                    self?.fetchPokemons(names: [trimmed])
                }
            }
            .store(in: &cancellables)
    }

    func fetchPokemons(names: [String]) {
        let publishers = names.map { service.fetchPokemon(name: $0) }
        Publishers.MergeMany(publishers)
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.pokemons = list.sorted { $0.id < $1.id }
            }
            .store(in: &cancellables)
    }
    func fetchRandomPokemons(count: Int = 5) {
        // 1. Defina o maior ID disponível (p. ex. 898)
        let maxId = 898
        // 2. Gere ‘count’ números aleatórios entre 1 e maxId
        let randomIds = Array(1...maxId).shuffled().prefix(count)
        // 3. Crie publishers de cada fetch pelo ID
        let publishers = randomIds.map { service.fetchPokemon(name: "\($0)") }

        // 4. Junte, trate erros e atualize o @Published
        Publishers.MergeMany(publishers)
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                // Ordena por ID e publica
                self?.pokemons = list.sorted { $0.id < $1.id }
            }
            .store(in: &cancellables)
    }
}
