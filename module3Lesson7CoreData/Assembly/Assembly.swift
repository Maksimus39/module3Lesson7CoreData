import Foundation

protocol AssemblyProtocol {
    func createContentViewModel() -> ContentViewModel
    func createNoteListViewModel(folder: FolderModel) -> NoteListViewModel
}

class Assembly: AssemblyProtocol {
    static let shared = Assembly()
    
    private let coreManager = CoreManager.shared
    
    func createContentViewModel() -> ContentViewModel {
        return ContentViewModel(coreManager: coreManager)
    }
    
    func createNoteListViewModel(folder: FolderModel) -> NoteListViewModel {
        return NoteListViewModel(folder: folder, coreManager: coreManager)
    }
}
