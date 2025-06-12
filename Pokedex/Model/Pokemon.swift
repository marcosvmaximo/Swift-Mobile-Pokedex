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
        var id = UUID() // Para conformar com Identifiable
        let name: String
        let value: Int
        
        // NOVO: Propriedade computada para abreviar o nome da estatística
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

// ... (O restante do arquivo, como PokemonDetail, continua o mesmo)
struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeElement]
    let sprites: Sprites
    let stats: [StatElement]
}

struct Sprites: Decodable {
    let frontDefault: String?
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
