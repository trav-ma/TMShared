//
//  TMCoreDataManager.swift
//  CarbCounter
//
//  Created by Travis Ma on 3/16/15.
//  Copyright (c) 2015 Travis Ma. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    var managedObjectContext: NSManagedObjectContext?
    private var diskSaveObjectContext: NSManagedObjectContext?
    var childObjectContext: NSManagedObjectContext?
    
    init(databaseName: String, groupPath: String? = nil) {
        var databaseLocation: NSURL?
        if groupPath == nil {
            databaseLocation = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last
        } else {
            databaseLocation = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(groupPath!)
        }
        let storeUrl = databaseLocation!.URLByAppendingPathComponent("\(databaseName).sqlite")
        print("\(storeUrl)")
        let modelUrl = NSBundle.mainBundle().URLForResource(databaseName, withExtension: "momd")!
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel(contentsOfURL: modelUrl)!)
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        do {
            try storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: options)
        } catch let error {
            print("CoreDataManager.init: \(error)")
        }
        diskSaveObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        diskSaveObjectContext?.persistentStoreCoordinator = storeCoordinator
        managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext?.parentContext = diskSaveObjectContext
    }
    
    func createChildContext() {
        childObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        childObjectContext?.parentContext = managedObjectContext
    }
    
    func childRecordForEntity(table: String, sorts: [NSSortDescriptor]?, format: String?, args: CVarArgType...) -> NSManagedObject? {
        var predicate: NSPredicate?
        if format != nil {
            predicate = NSPredicate(format: format!, arguments: getVaList(args))
        }
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: table)
        fetchRequest.fetchLimit = 1
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sorts != nil {
            fetchRequest.sortDescriptors = sorts
        }
        let fetchedObjects: [AnyObject]?
        do {
            fetchedObjects = try childObjectContext?.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            fetchedObjects = nil
        }
        if error != nil {
            print("CoreDataManager.recordForEntity: \(error)")
            return nil
        } else if fetchedObjects?.count == 0 {
            return nil
        } else {
            return fetchedObjects?.first as? NSManagedObject
        }
    }
    
    func recordForEntity(table: String, sorts: [NSSortDescriptor]?, format: String?, args: CVarArgType...) -> NSManagedObject? {
        var predicate: NSPredicate?
        if format != nil {
            predicate = NSPredicate(format: format!, arguments: getVaList(args))
        }
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: table)
        fetchRequest.fetchLimit = 1
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sorts != nil {
            fetchRequest.sortDescriptors = sorts
        }
        let fetchedObjects: [AnyObject]?
        do {
            fetchedObjects = try managedObjectContext?.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            fetchedObjects = nil
        }
        if error != nil {
            print("CoreDataManager.recordForEntity: \(error)")
            return nil
        } else if fetchedObjects?.count == 0 {
            return nil
        } else {
            return fetchedObjects?.first as? NSManagedObject
        }
    }
    
    func childRecordsForEntity(table: String, sorts: [NSSortDescriptor]?, format: String?, args: CVarArgType...) -> [NSManagedObject] {
        var predicate: NSPredicate?
        if format != nil {
            predicate = NSPredicate(format: format!, arguments: getVaList(args))
        }
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: table)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sorts != nil {
            fetchRequest.sortDescriptors = sorts
        }
        let fetchedObjects: [AnyObject]?
        do {
            fetchedObjects = try childObjectContext?.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            fetchedObjects = nil
        }
        if error != nil {
            print("CoreDataManager.recordsForEntity: \(error)")
            return []
        } else if fetchedObjects?.count == 0 {
            return []
        } else {
            return fetchedObjects as! [NSManagedObject]
        }
    }
    
    func recordsForEntity(table: String, sorts: [NSSortDescriptor]?, format: String?, args: CVarArgType...) -> [NSManagedObject] {
        var predicate: NSPredicate?
        if format != nil {
            predicate = NSPredicate(format: format!, arguments: getVaList(args))
        }
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: table)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sorts != nil {
            fetchRequest.sortDescriptors = sorts
        }
        let fetchedObjects: [AnyObject]?
        do {
            fetchedObjects = try managedObjectContext?.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            fetchedObjects = nil
        }
        if error != nil {
            print("CoreDataManager.recordsForEntity: \(error)")
            return []
        } else if fetchedObjects?.count == 0 {
            return []
        } else {
            return fetchedObjects as! [NSManagedObject]
        }
    }
    
    func dictionariesForEntity(table: String, fields:[String]?, sorts: [NSSortDescriptor]?, format: String?, args: CVarArgType...) -> [[String: AnyObject]] {
        var predicate: NSPredicate?
        if format != nil {
            predicate = NSPredicate(format: format!, arguments: getVaList(args))
        }
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: table)
        fetchRequest.resultType = .DictionaryResultType
        fetchRequest.propertiesToFetch = fields
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sorts != nil {
            fetchRequest.sortDescriptors = sorts
        }
        let fetchedObjects: [[String: AnyObject]]?
        do {
            fetchedObjects = try managedObjectContext?.executeFetchRequest(fetchRequest) as? [[String: AnyObject]]
        } catch let error1 as NSError {
            error = error1
            fetchedObjects = nil
        }
        if error != nil {
            print("CoreDataManager.dictionariesForEntity: \(error)")
            return []
        } else if fetchedObjects?.count == 0 {
            return []
        } else {
            return fetchedObjects!
        }
    }
    
    func dictionaryForEntity(table: String, fields:[String]?, sorts: [NSSortDescriptor]?, format: String?, args: CVarArgType...) -> [String: AnyObject]? {
        var predicate: NSPredicate?
        if format != nil {
            predicate = NSPredicate(format: format!, arguments: getVaList(args))
        }
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: table)
        fetchRequest.fetchLimit = 1
        fetchRequest.resultType = .DictionaryResultType
        fetchRequest.propertiesToFetch = fields
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sorts != nil {
            fetchRequest.sortDescriptors = sorts
        }
        let fetchedObjects: [[String: AnyObject]]?
        do {
            fetchedObjects = try managedObjectContext?.executeFetchRequest(fetchRequest) as? [[String: AnyObject]]
        } catch let error1 as NSError {
            error = error1
            fetchedObjects = nil
        }
        if error != nil {
            print("CoreDataManager.dictionaryForEntity: \(error)")
            return nil
        } else if fetchedObjects?.count == 0 {
            return nil
        } else {
            return fetchedObjects?.first
        }
    }
    
    func newChildRecordForEntity(table: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(table, inManagedObjectContext: childObjectContext!)
    }
    
    func newRecordForEntity(table: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(table, inManagedObjectContext: managedObjectContext!)
    }
    
    func deleteAllRecordsInEntity(table: String) {
        let records = self.recordsForEntity(table, sorts: nil, format: nil)
        for record in records {
            managedObjectContext?.deleteObject(record)
        }
    }
    
    func deleteChildRecord(record: NSManagedObject) {
        childObjectContext?.deleteObject(record)
    }
    
    func deleteRecord(record: NSManagedObject) {
        managedObjectContext?.deleteObject(record)
    }
    
    func saveAndDiscardChild() {
        if childObjectContext!.hasChanges {
            do {
                try childObjectContext!.save()
            } catch let error {
                print("CoreDataManager.save (childObject): \(error)")
            }
        }
        save()
        childObjectContext = nil
    }
    
    func save() {
        if managedObjectContext!.hasChanges {
            do {
                try managedObjectContext!.save()
            } catch let error {
                print("CoreDataManager.save (managedObject): \(error)")
            }
        }
        if diskSaveObjectContext!.hasChanges {
            do {
                try diskSaveObjectContext!.save()
            } catch let error {
                print("CoreDataManager.save (diskSave): \(error)")
            }
        }
    }
    
    func rollback() {
        if managedObjectContext!.hasChanges {
            managedObjectContext!.rollback()
        }
    }
    
}
