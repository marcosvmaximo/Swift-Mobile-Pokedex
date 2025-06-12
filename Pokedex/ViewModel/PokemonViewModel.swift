// Swift-Mobile-Pokedex/Pokedex/ViewModel/PokemonViewModel.swift

import Foundation
import Combine

final class PokemonViewModel: ObservableObject {
    @Published var pokemons: [PokemonModel] = []
    @Published var searchText: String = ""
    
    // Estado da UI
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // NOVO: Controle para a lógica de busca vs. navegação
    @Published private(set) var isSearching = false

    private var cancellables = Set<AnyCancellable>()
    private let service = PokemonService.shared
    
    // NOVO: Controle de paginação
    private var offset = 0
    private let limit = 20

    init() {
        // A busca inicial de Pokémon foi movida para a ContentView (.onAppear)
        
        $searchText
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] term in
                guard let self = self else { return }
                
                let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                
                // Se o texto estiver vazio, saímos do modo de busca
                if trimmed.isEmpty {
                    self.isSearching = false
                    self.pokemons = [] // Limpa os resultados da busca
                    self.offset = 0 // Reseta a paginação
                    self.fetchNextBatchOfPokemons() // Carrega o lote inicial
                } else {
                    // Se há texto, entramos no modo de busca
                    self.isSearching = true
                    self.fetchPokemonByName(name: trimmed)
                }
            }
            .store(in: &cancellables)
    }

    // Função para buscar um único Pokémon pelo nome
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
                    self?.pokemons = [] // Garante que a lista fique vazia em caso de erro
                }
            }, receiveValue: { [weak self] pokemon in
                self?.pokemons = [pokemon]
            })
            .store(in: &cancellables)
    }
    
    // NOVO: Função para buscar o próximo lote de Pokémon (Paginação)
    func fetchNextBatchOfPokemons() {
        // Não busca mais se já estiver carregando ou se estiver em modo de busca
        guard !isLoading, !isSearching else { return }
        
        self.isLoading = true
        self.errorMessage = nil
        
        // 1. Busca a lista de nomes/URLs
        service.fetchPokemonList(limit: limit, offset: offset)
            .flatMap { items -> AnyPublisher<[PokemonModel], Error> in
                // 2. Para cada item da lista, busca seus detalhes completos
                let publishers = items.map { item in
                    self.service.fetchPokemon(name: item.name)
                        .catch { error -> Empty<PokemonModel, Error> in
                            print("Falha ao buscar detalhes do Pokémon: \(item.name), Erro: \(error.localizedDescription)")
                            return Empty() // Ignora o Pokémon que falhou
                        }
                }
                // Une todos os resultados
                return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Erro ao buscar a lista de Pokémon: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] newPokemons in
                // Adiciona os novos Pokémon à lista existente e ordena por ID
                self?.pokemons.append(contentsOf: newPokemons)
                self?.pokemons.sort { $0.id < $1.id }
                // Prepara para a próxima página
                self?.offset += self?.limit ?? 20
            })
            .store(in: &cancellables)
    }
}
