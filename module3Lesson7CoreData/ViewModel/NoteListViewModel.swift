import Foundation
import Observation


protocol NoteListViewModelProtocol: AnyObject {
    func addNote(text: String, imageFileName: String?)
    func loadNotes()
    func updateNoteText(_ noteModel: NoteModel, newText: String)
    func deleteNote(_ noteModel: NoteModel)
}


@Observable final class NoteListViewModel: NoteListViewModelProtocol {
    private let coreManager: CoreManager
    
    private let folderId: String
    
    var notes: [NoteModel] = []
    var errorMessage: String?
    var showError: Bool = false
    
    init(folder: FolderModel, coreManager: CoreManager = .shared) {
        self.folderId = folder.id
        self.coreManager = coreManager
        loadNotes()
    }
    
    // Create
    func addNote(text: String, imageFileName: String?) {
        do {
            try coreManager.createNote(text: text, imageFileName: imageFileName, folderId: folderId)
            loadNotes()
        } catch {
            handleError(error)
        }
    }
    
    // Read
    func loadNotes() {
        do {
            notes = try coreManager.fetchNotes(forFolderId: folderId)
        } catch {
            handleError(error)
        }
    }
    
    // Update
    func updateNoteText(_ noteModel: NoteModel, newText: String) {
        do {
            try coreManager.updateNoteText(noteId: noteModel.id, newText: newText)
            loadNotes()
        } catch {
            handleError(error)
        }
    }
    
    // Delete
    func deleteNote(_ noteModel: NoteModel) {
        do {
            try coreManager.deleteNote(noteId: noteModel.id)
            loadNotes()
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
