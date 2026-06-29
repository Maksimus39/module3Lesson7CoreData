import Foundation


struct FolderModel: Identifiable {
    let id: String
    let name: String
    let date: Date
}


struct NoteModel: Identifiable {
    let id: String
    let text: String
    let imageFileName: String?
    let date: Date
    let folderId: String
}
