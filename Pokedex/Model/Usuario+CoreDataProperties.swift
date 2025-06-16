//
//  Usuario+CoreDataProperties.swift
//  Pokedex
//
//  Created by Marcos Máximo on 16/06/25.
//
//

import Foundation
import CoreData


extension Usuario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuario> {
        return NSFetchRequest<Usuario>(entityName: "Usuario")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nomeUsuario: String?
    @NSManaged public var email: String?
    @NSManaged public var senha: String?
    @NSManaged public var favoritos: NSSet?

}

// MARK: Generated accessors for favoritos
extension Usuario {

    @objc(addFavoritosObject:)
    @NSManaged public func addToFavoritos(_ value: PokemonFavorito)

    @objc(removeFavoritosObject:)
    @NSManaged public func removeFromFavoritos(_ value: PokemonFavorito)

    @objc(addFavoritos:)
    @NSManaged public func addToFavoritos(_ values: NSSet)

    @objc(removeFavoritos:)
    @NSManaged public func removeFromFavoritos(_ values: NSSet)

}

extension Usuario : Identifiable {

}
