import Foundation
import Observation
import CoreData


protocol ContentViewModelProtocol: AnyObject {
    func createFolder(titleFolder: String)
    func loadFolders()
    func updateFolder(_ folderModel: FolderModel, newName: String)
    func deleteFolder(_ folderModel: FolderModel)
}

@Observable final class ContentViewModel: ContentViewModelProtocol {
    
    private let coreManager: CoreManager
    
    var folders: [FolderModel] = []
    var errorMessage: String?
    var showError: Bool = false
    
    init(coreManager: CoreManager = .shared) {
        self.coreManager = coreManager
        loadFolders()
    }
    
    func createFolder(titleFolder: String) {
        do {
            try coreManager.createFolder(name: titleFolder)
            loadFolders()
        } catch {
            handleError(error)
        }
    }
    
    func loadFolders() {
        do {
            folders = try coreManager.fetchFolders()
        } catch {
            handleError(error)
        }
    }
    
    func updateFolder(_ folderModel: FolderModel, newName: String) {
        do {
            let request = NSFetchRequest<Folder>(entityName: "Folder")
            request.predicate = NSPredicate(format: "id == %@", folderModel.id)
            if (try coreManager.viewContext.fetch(request).first) != nil {
                try coreManager.updateFolder(id: folderModel.id, newName: newName)
                loadFolders()
            }
        } catch {
            handleError(error)
        }
    }
    
    func deleteFolder(_ folderModel: FolderModel) {
        do {
            let request = NSFetchRequest<Folder>(entityName: "Folder")
            request.predicate = NSPredicate(format: "id == %@", folderModel.id)
            if (try coreManager.viewContext.fetch(request).first) != nil {
                try coreManager.deleteFolder(id: folderModel.id)
                loadFolders()
            }
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
