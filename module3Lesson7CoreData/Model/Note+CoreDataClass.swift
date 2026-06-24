public import Foundation
public import CoreData

public typealias NoteCoreDataClassSet = NSSet

@objc(Note)
public class Note: NSManagedObject {

}

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var text: String?
    @NSManaged public var folder: Folder? // as? [Nones]

}

extension Note : Identifiable {

}

