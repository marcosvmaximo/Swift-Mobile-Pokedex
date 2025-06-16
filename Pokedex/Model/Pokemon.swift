// Em Pokedex/Model/Pokemon.swift
// VERSÃO CORRIGIDA

import Foundation

// A estrutura principal não muda
struct PokemonModel: Identifiable, Decodable {
    let id: Int
    let name: String
    let types: [String]
    let imageURL: URL?
    let height: Double
    let weight: Double
    let stats: [Stat]

    struct Stat: Identifiable, Decodable {
        var id = UUID()
        let name: String
        let value: Int
        
        var abbreviatedName: String {
            let lowercasedName = name.lowercased()
            switch lowercasedName {
            case "hp":
                return "HP"
            case "attack":
                return "ATK"
            case "defense":
                return "DEF"
            case "special-attack":
                return "Sp. Atk"
            case "special-defense":
                return "Sp. Def"
            case "speed":
                return "SPD"
            default:
                return name.capitalized
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case name, value
        }
    }
}


// --- PONTO CHAVE DA CORREÇÃO ---
// As structs abaixo foram atualizadas para acessar a imagem de alta qualidade.

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeElement]
    let sprites: Sprites // A estrutura de Sprites agora é mais complexa
    let stats: [StatElement]
}

// NOVO: Struct para decodificar o campo "official-artwork"
struct OfficialArtwork: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// NOVO: Struct para decodificar o campo "other"
struct OtherSprites: Decodable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// ATUALIZADO: A struct Sprites agora contém a "other" para acessar a imagem de alta qualidade
struct Sprites: Decodable {
    let frontDefault: String? // Mantido como fallback (backup)
    let other: OtherSprites?
}

struct StatElement: Decodable {
    let baseStat: Int
    let stat: Species
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct Species: Decodable {
    let name: String
}

struct TypeElement: Decodable {
    let slot: Int
    let type: Species
}
