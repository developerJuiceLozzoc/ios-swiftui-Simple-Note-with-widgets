//
//  Persistence.swift
//  SimpleNotes
//
//  Created by Conner M on 1/19/21.
//

import CoreData

public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "NoteCoreData")
        let storeURL =  URL.storeURL(for: "group.com.lozzoc.SimpleNotes", databaseName: "NoteCoreData")
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        let cloud = NSPersistentStoreDescription(url:  storeURL)
        cloud.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.lozzoc.SimpleNotes")
        container.persistentStoreDescriptions = [cloud]
        
        print(cloud)
       
//        let cloudURL = URL.storeURL(for: "iCloud.com.lozzoc.SimpleNotes", databaseName: "NoteCoreData")
       
//        let local = NSPersistentStoreDescription(url:  cloudURL)

     
       
//        

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
