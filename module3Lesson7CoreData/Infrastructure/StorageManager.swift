import Foundation
import UIKit 



class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private var documentsPath: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // Сохраняем Data и возвращаем имя файла для записи в CoreData
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
    
    // Загружаем Data по имени файла
    func loadImage(fileName: String?) -> UIImage? {
        guard let fileName = fileName else { return nil }
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        return nil
    }
}
