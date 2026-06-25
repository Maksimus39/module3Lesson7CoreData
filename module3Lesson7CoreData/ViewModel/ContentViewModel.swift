import Foundation
import Observation
import CoreData



@Observable final class ContentViewModel {
    private let coreManager: CoreManager
    
    var folders: [Folder] = []
    var errorMessage: String?
    var showError: Bool = false
    var updateCounter: Int = 0
    
    init(coreManager: CoreManager = .shared) {
        self.coreManager = coreManager
        loadFolder()
    }
    
    
    // Create
    func createFolder(titleFolder: String) {
        do {
            _ = try coreManager.createDB(Folder.self) {
                $0.id = UUID().uuidString
                $0.date = Date()
                $0.name = titleFolder
            }
            loadFolder()
        } catch {
            handleError(error)
        }
    }
    
    // Read
    func loadFolder() {
        do {
            let sortDescriptor = NSSortDescriptor(keyPath: \Folder.date, ascending: false)
            folders = try coreManager.fetchDB(Folder.self, sortDescriptor: sortDescriptor)
            
            updateCounter += 1
        } catch {
            handleError(error)
        }
    }
    
    
    // Update
    func updateFolder(_ folder: Folder, newName: String) {
        do {
            try coreManager.updateDB(folder) {
                $0.name = newName
                $0.date = Date()
            }
            loadFolder()
        } catch {
            handleError(error)
        }
    }
    
    // Delete
    func deleteFolder(_ folder: Folder) {
        do {
            try coreManager.deleteDB(folder)
            loadFolder()
        } catch {
            handleError(error)
        }
    }
    
    // error
    func handleError (_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
