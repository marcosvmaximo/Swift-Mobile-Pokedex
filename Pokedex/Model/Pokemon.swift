import Foundation

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

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeElement]
    let sprites: Sprites
    let stats: [StatElement]
}

struct OfficialArtwork: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct OtherSprites: Decodable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// --- PONTO CHAVE DA CORREÇÃO ---
struct Sprites: Decodable {
    let frontDefault: String?
    let other: OtherSprites?

    // Este enum foi adicionado para garantir que o Swift decodifique
    // corretamente o campo "front_default" da API.
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
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
