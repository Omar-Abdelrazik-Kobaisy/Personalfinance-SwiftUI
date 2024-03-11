//
//  PersistenceController.swift
//  Pfinance
//
//  Created by Omar on 09/03/2024.
//

import Foundation
import CoreData
struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false){
        container = NSPersistentContainer(name: "Pfinance")
        if inMemory{
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: {storeDescription , error in
            if let error = error as? NSError{
                fatalError("unresolved error \(error), \(error.userInfo)")
            }
            
        })
    }
}
