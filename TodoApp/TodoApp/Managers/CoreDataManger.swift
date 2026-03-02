//
//  Untitled.swift
//  TodoApp
//
//  Created by RaviShankar Kushwaha on 02/03/26.
//

import Foundation
import CoreData

class CoreDataManger {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManger = CoreDataManger()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TodoApp")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
}
