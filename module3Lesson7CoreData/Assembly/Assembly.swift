import Foundation


// DI
class Assembly {
    private static let coreManager = CoreManager.shared
    
    static func createContentViewModel() -> ContentViewModel {
        return ContentViewModel(coreManager: coreManager)
    }
    
    static func createNoteListViewModel(folder: FolderModel) -> NoteListViewModel {
        return NoteListViewModel(folder: folder, coreManager: coreManager)
    }
}
