//
//  CoreDataManager.swift
//  MediaRelease
//
//  Created by Chris Galindo on 4/6/16.
//  Copyright © 2016 State Farm. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    var context: NSManagedObjectContext!
    private var diskSaveObjectContext: NSManagedObjectContext!
    
    init(databaseName: String) {
        let databaseLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let storeUrl = databaseLocation.appendingPathComponent("\(databaseName).sqlite")
        print("\(storeUrl)")
        let modelUrl = Bundle.main.url(forResource: databaseName, withExtension: "momd")!
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel(contentsOf: modelUrl)!)
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
        } catch {
            print("CoreDataManager.init: \(error)")
        }
        diskSaveObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        diskSaveObjectContext.persistentStoreCoordinator = storeCoordinator
        context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = diskSaveObjectContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
                if diskSaveObjectContext.hasChanges {
                    try diskSaveObjectContext.save()
                }
            } catch {
                print("CoreDataManager.save: \(error)")
            }
        }
    }
    
}

extension NSManagedObject {
    
    class func addRecord(toContext context: NSManagedObjectContext) -> NSManagedObject? {
        guard let className = NSStringFromClass(classForCoder()).components(separatedBy: ".").last else {
            return nil
        }
        var managedObject: NSManagedObject?
        if let entity = NSEntityDescription.entity(forEntityName: className, in: context) {
            managedObject = NSManagedObject(entity: entity, insertInto: context)
        }
        return managedObject
    }
    
}

