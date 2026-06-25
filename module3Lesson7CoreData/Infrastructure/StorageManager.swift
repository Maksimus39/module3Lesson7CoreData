import Foundation



class StorageManager {
    var path = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
    
    
    func saveImage(name: String, image: Data) {
        do {
            let imageURL = path.appending(path: "\(name).jpeg")
            try  image.write(to: imageURL)
        } catch {
            print(error)
        }
    }
    
    func loadImage(name: String) -> Data? {
        let imagePath = path.appending(path: "\(name).jpeg")
        do {
            let imgData = try Data(contentsOf: imagePath)
        } catch {
            print(error)
        }
        return nil
    }
}
