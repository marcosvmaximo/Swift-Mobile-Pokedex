//
//  PokemonFavorito+CoreDataProperties.swift
//  Pokedex
//
//  Created by Marcos Máximo on 16/06/25.
//
//

import Foundation
import CoreData


extension PokemonFavorito {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonFavorito> {
        return NSFetchRequest<PokemonFavorito>(entityName: "PokemonFavorito")
    }

    @NSManaged public var pokemonID: Int64
    @NSManaged public var nome: String?
    @NSManaged public var imagemUrl: String?
    @NSManaged public var tipos: String?
    @NSManaged public var usuario: Usuario?

}

extension PokemonFavorito : Identifiable {

}
