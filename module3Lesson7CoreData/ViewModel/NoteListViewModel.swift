import Foundation
import Observation
import CoreData



protocol NoteListViewModelProtocol: AnyObject {
    func addNote(text: String, image: String?)
    func loadNotes()
    func updateNote(_ note: Note, newText: String, newImage: String?)
    func deleteNote(_ note: Note)
}


@Observable final class NoteListViewModel: NoteListViewModelProtocol {
    private let coreManager: CoreManager
    private let folder: Folder
    
    var notes: [Note] = []
    var errorMessage: String?
    var showError: Bool = false
    
    init(folder: Folder, coreManager: CoreManager = .shared) {
        self.folder = folder
        self.coreManager = coreManager
        loadNotes()
    }
    
    // Create
    func addNote(text: String, image: String? = nil) {
        do {
            _ = try coreManager.createDB(Note.self) {
                $0.id = UUID().uuidString
                $0.text = text
                $0.image = image
                $0.date = Date().description
                $0.folder = self.folder
            }
            loadNotes()
        } catch {
            handleError(error)
        }
    }
    
    // Read
    func loadNotes() {
        do {
            let predicate = NSPredicate(format: "folder == %@", folder)
            let sortDescriptor = NSSortDescriptor(keyPath: \Note.date, ascending: false)
            
            notes = try coreManager.fetchDB(Note.self, predicate: predicate, sortDescriptor: sortDescriptor)
        } catch {
            handleError(error)
        }
    }
    
    // Update
    func updateNote(_ note: Note, newText: String, newImage: String? = nil) {
        do {
            try coreManager.updateDB(note) {
                $0.text = newText
                if let image = newImage {
                    $0.image = image
                }
                $0.date = Date().description
            }
            loadNotes()
        } catch {
            handleError(error)
        }
    }
    
    // Update Note Text 
    func updateNoteText(_ note: Note, newText: String) {
        updateNote(note, newText: newText, newImage: note.image)
    }
    
    // Delete
    func deleteNote(_ note: Note) {
        do {
            try coreManager.deleteDB(note)
            loadNotes()
        } catch {
            handleError(error)
        }
    }
    
    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
