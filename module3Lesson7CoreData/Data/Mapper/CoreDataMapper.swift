import CoreData



protocol CoreDataMapperProtocol {
    static func map(folder: Folder) -> FolderModel?
    static func map(folders: [Folder]) -> [FolderModel]
    
    static func map(note: Note) -> NoteModel?
    static func map(notes: [Note]) -> [NoteModel]       
}


class CoreDataMapper: CoreDataMapperProtocol {
    
    static func map(folder: Folder) -> FolderModel? {
        guard let id = folder.id,
              let name = folder.name,
              let date = folder.date else { return nil }
        
        return FolderModel(id: id, name: name, date: date)
    }
    
    static func map(folders: [Folder]) -> [FolderModel] {
        return folders.compactMap { map(folder: $0) }
    }
    

    static func map(note: Note) -> NoteModel? {
        guard let id = note.id,
              let text = note.text,
              let dateStr = note.date,
              let folderId = note.folder?.id else { return nil }
        
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        let date = dateFormatter.date(from: dateStr) ?? Date()
        
        return NoteModel(id: id, text: text, imageFileName: note.image, date: date, folderId: folderId)
    }
    
    static func map(notes: [Note]) -> [NoteModel] {
        return notes.compactMap { map(note: $0) }
    }
}
