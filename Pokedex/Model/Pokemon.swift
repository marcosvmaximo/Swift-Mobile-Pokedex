import Foundation

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let types: [TypeSlot]
    let sprites: Sprites

    struct TypeSlot: Decodable {
        let slot: Int
        let type: TypeInfo
        struct TypeInfo: Decodable {
            let name: String
        }
    }

    struct Sprites: Decodable {
        let frontDefault: String?
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}

struct PokemonModel: Identifiable {
    let id: Int
    let name: String
    let types: [String]
    let imageURL: URL?
}
