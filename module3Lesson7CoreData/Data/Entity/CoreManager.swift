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
        let context = viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
   
    private func fetchObject<T: NSManagedObject>(type: T.Type, id: String) throws -> T? {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1 
        return try viewContext.fetch(request).first
    }
    
  
    private func create<T: NSManagedObject>(_ type: T.Type, configure: (T) -> Void) throws -> T {
        let entity = T(context: viewContext)
        configure(entity)
        try saveContext()
        return entity
    }

    
    func createFolder(name: String) throws {
        _ = try create(Folder.self) {
            $0.id = UUID().uuidString
            $0.date = Date()
            $0.name = name
        }
    }
    
    func fetchFolders() throws -> [FolderModel] {
        let request = NSFetchRequest<Folder>(entityName: "Folder")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Folder.date, ascending: false)]
        let folders = try viewContext.fetch(request)
        return CoreDataMapper.map(folders: folders)
    }
    
    func updateFolder(id: String, newName: String) throws {
        guard let folder = try fetchObject(type: Folder.self, id: id) else { return }
        
        try updateDB(folder) {
            $0.name = newName
            $0.date = Date()
        }
    }
    
    func deleteFolder(id: String) throws {
        guard let folder = try fetchObject(type: Folder.self, id: id) else { return }
        try deleteDB(folder)
    }
    
    
    func createNote(text: String, imageFileName: String?, folderId: String) throws {
        guard let folder = try fetchObject(type: Folder.self, id: folderId) else {
            throw NSError(domain: "CoreManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Folder not found"])
        }
        
        _ = try create(Note.self) {
            $0.id = UUID().uuidString
            $0.text = text
            $0.image = imageFileName
            $0.date = Date().description
            $0.folder = folder
        }
    }
    
    func fetchNotes(forFolderId folderId: String) throws -> [NoteModel] {
        let request = NSFetchRequest<Note>(entityName: "Note")
        request.predicate = NSPredicate(format: "folder.id == %@", folderId)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.date, ascending: false)]
        
        let notes = try viewContext.fetch(request)
        return CoreDataMapper.map(notes: notes)
    }
    
    func updateNoteText(noteId: String, newText: String) throws {
        guard let note = try fetchObject(type: Note.self, id: noteId) else { return }
        
        try updateDB(note) {
            $0.text = newText
            $0.date = Date().description
        }
    }
    
    func deleteNote(noteId: String) throws {
        guard let note = try fetchObject(type: Note.self, id: noteId) else { return }
        try deleteDB(note)
    }
    
    
    private func updateDB<T: NSManagedObject>(_ entity: T, configure: (T) -> Void) throws {
        configure(entity)
        try saveContext()
    }
    
    private func deleteDB(_ object: NSManagedObject) throws {
        viewContext.delete(object)
        try saveContext()
    }
}
