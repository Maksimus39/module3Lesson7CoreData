import Foundation
import CoreData



class CoreManager {
    static let shared = CoreManager()
    private init () {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "db")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    
    func saveContext() throws {
        let contex = viewContext
        if contex.hasChanges {
            do {
                try contex.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error: \(nsError), \(nsError.userInfo)")
                // Здесь можно добавить обработку ошибки, например, показать alert во View
            }
        }
    }
    
    // C
    func createDB<T: NSManagedObject>(_ type: T.Type, configure: (T) -> Void) throws -> T {
        let entity = T(context: viewContext)
        configure(entity)
        try saveContext()
        
        return entity
    }
    
    // R
    func fetchDB<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptor: NSSortDescriptor? = nil
    ) throws -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        if let sortDescriptor = sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        
        return try viewContext.fetch(request)
    }
    
    
    // U
    func updateDB<T: NSManagedObject>(_ entity: T, configure: (T) -> Void) throws {
        configure(entity)
        try saveContext()
    }
    
    // D
    func deleteDB(_ object: NSManagedObject) throws {
        viewContext.delete(object)
        try saveContext()
    }
}
