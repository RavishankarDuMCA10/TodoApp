//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by RaviShankar Kushwaha on 02/03/26.
//

import SwiftUI
import CoreData

@main
struct TodoAppApp: App {
    let persistenceContainer = CoreDataManger.shared.persistentContainer

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceContainer.viewContext)
        }
    }
}
