public import Foundation
public import CoreData

public typealias FolderCoreDataClassSet = NSSet

@objc(Folder)
public class Folder: NSManagedObject {

}

extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var id: String?
    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension Folder {

}

extension Folder : Identifiable {

}

