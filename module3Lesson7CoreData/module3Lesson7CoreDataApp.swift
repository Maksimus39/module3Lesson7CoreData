//
//  module3Lesson7CoreDataApp.swift
//  module3Lesson7CoreData
//
//  Created by Максим Минаков on 12.06.2026.
//

import SwiftUI
import CoreData

@main
struct module3Lesson7CoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
