import CoreData

class CoreDataManager {
    static let shared = CoreDataManager(modelName: "Pokedex")
    
    let container: NSPersistentContainer

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
