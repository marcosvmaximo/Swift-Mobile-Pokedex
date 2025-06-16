import Foundation
import Combine

final class PokemonViewModel: ObservableObject {
    @Published var pokemons: [PokemonModel] = []
    @Published var searchText: String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published private(set) var isSearching = false

    private var cancellables = Set<AnyCancellable>()
    private let service = PokemonService.shared
    
    private var offset = 0
    private let limit = 20

    init() {
        $searchText
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] term in
                guard let self = self else { return }
                
                let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                
                if trimmed.isEmpty {
                    self.isSearching = false
                    self.pokemons = []
                    self.offset = 0
                    self.fetchNextBatchOfPokemons()
                } else {
                    self.isSearching = true
                    self.fetchPokemonByName(name: trimmed)
                }
            }
            .store(in: &cancellables)
    }

    func fetchPokemonByName(name: String) {
        self.pokemons = []
        self.isLoading = true
        self.errorMessage = nil
        
        service.fetchPokemon(name: name)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure = completion {
                    self?.errorMessage = "Oops! Não encontramos o Pokémon \"\(name)\". Tente novamente."
                    self?.pokemons = []
                }
            }, receiveValue: { [weak self] pokemon in
                self?.pokemons = [pokemon]
            })
            .store(in: &cancellables)
    }
    
    func fetchNextBatchOfPokemons() {
        guard !isLoading, !isSearching else { return }
        
        self.isLoading = true
        self.errorMessage = nil
        
        service.fetchPokemonList(limit: limit, offset: offset)
            .flatMap { items -> AnyPublisher<[PokemonModel], Error> in
                let publishers = items.map { item in
                    self.service.fetchPokemon(name: item.name)
                        .catch { error -> Empty<PokemonModel, Error> in
                            print("Falha ao buscar detalhes do Pokémon: \(item.name), Erro: \(error.localizedDescription)")
                            return Empty()
                        }
                }
                return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Erro ao buscar a lista de Pokémon: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] newPokemons in
                self?.pokemons.append(contentsOf: newPokemons)
                self?.pokemons.sort { $0.id < $1.id }
                self?.offset += self?.limit ?? 20
            })
            .store(in: &cancellables)
    }
}
