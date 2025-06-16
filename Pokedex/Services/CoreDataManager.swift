// Em Pokedex/Services/CoreDataManager.swift

import CoreData

class CoreDataManager {
    // A instância compartilhada (Singleton) continua a mesma
    static let shared = CoreDataManager(modelName: "Pokedex")
    
    let container: NSPersistentContainer

    // --- ALTERAÇÃO PRINCIPAL ---
    // Tornamos o inicializador privado para garantir que nenhuma outra
    // instância possa ser criada fora desta classe.
    private init(modelName: String) {
        container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Erro ao carregar Core Data: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Erro ao salvar contexto: \(error)")
            }
        }
    }
}
