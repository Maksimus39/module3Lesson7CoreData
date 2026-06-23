//
//  Note+CoreDataProperties.swift
//  module3Lesson7CoreData
//
//  Created by Максим Минаков on 23.06.2026.
//
//

public import Foundation
public import CoreData


public typealias NoteCoreDataPropertiesSet = NSSet

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var text: String?
    @NSManaged public var folder: Folder?

}

extension Note : Identifiable {

}
