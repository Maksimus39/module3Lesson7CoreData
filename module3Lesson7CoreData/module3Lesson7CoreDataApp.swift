import SwiftUI

@main
struct module3Lesson7CoreDataApp: App {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "db")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    @StateObject private var coreManager: CoreManager

    init() {
        _coreManager = StateObject(wrappedValue: CoreManager(container: persistentContainer))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                .environmentObject(coreManager)
            
        }
    }
}
