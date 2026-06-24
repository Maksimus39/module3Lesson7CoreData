import Foundation
import CoreData
import Combine

class CoreManager: ObservableObject {
    let container: NSPersistentContainer
    
    @Published var folders: [Folder] = []
    
    init(container: NSPersistentContainer) {
        self.container = container
        fetchAllFolders()
    }
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    
    func createFolder(name: String) {
        let folder = Folder(context: viewContext)
        folder.id = UUID().uuidString
        folder.name = name
        folder.date = Date()
        
        saveContext()
        fetchAllFolders()
    }
    
    func addNote(to folder: Folder, text: String, image: String? = nil) {
        let note = Note(context: viewContext)
        note.id = UUID().uuidString
        note.text = text
        note.image = image
        note.date = Date().description
        note.folder = folder
        
        saveContext()
    }
    
    func fetchAllFolders() {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Folder.date, ascending: false)]
        
        do {
            self.folders = try viewContext.fetch(request)
        } catch {
            print("Ошибка загрузки папок: \(error.localizedDescription)")
        }
    }
    
    func updateFolder(_ folder: Folder, newName: String) {
        folder.name = newName
        folder.date = Date()
        saveContext()
        fetchAllFolders()
    }
    
    func updateNote(_ note: Note, newText: String) {
        note.text = newText
        saveContext()
    }
    
    
    func deleteFolder(_ folder: Folder) {
        viewContext.delete(folder)
        saveContext()
        fetchAllFolders()
    }
    
    func deleteNote(_ note: Note) {
        viewContext.delete(note)
        saveContext()
    }
    
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Ошибка сохранения: \(error.localizedDescription)")
            }
        }
    }
}
