import Foundation
import UIKit 



protocol StorageManagerProtocol: AnyObject {
    func saveImage(data: Data) -> String?
    func loadImage(fileName: String?) -> UIImage?
}


class StorageManager: StorageManagerProtocol {
    static let shared = StorageManager()
    private init() {}
    
    private var documentsPath: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
    func saveImage(data: Data) -> String? {
        let fileName = UUID().uuidString + ".jpeg"
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Ошибка сохранения картинки: \(error)")
            return nil
        }
    }
    
   
    func loadImage(fileName: String?) -> UIImage? {
        guard let fileName = fileName else { return nil }
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        return nil
    }
}
