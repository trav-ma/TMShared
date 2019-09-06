//
//  CoreDataHelper.swift
//  DailyFast
//
//  Created by Travis Ma on 8/24/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import Foundation
import CoreData

var databaseName: String?

let databaseContainer: NSPersistentContainer = {
    print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last! as String)
    let container = NSPersistentContainer(name: databaseName ?? "Model")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error {
            fatalError("Unresolved error \(error)")
        }
    })
    return container
}()

var dbContext: NSManagedObjectContext {
    return databaseContainer.viewContext
}

//example upsert
//dbContext.performAndWait {
//    let request: NSFetchRequest<Day> = Day.fetchRequest()
//    request.predicate = NSPredicate(format: "dayId = %@", dayId)
//    request.fetchLimit = 1
//    let dayRecord: Day!
//    if let days = try? request.execute(), let day = days.first {
//        dayRecord = day
//    } else {
//        dayRecord = Day(context: dbContext)
//    }
//    dayRecord.dayId = dayId
//    dayRecord.isDayOff = false
//    try? dbContext.save()
//}

//example fetch
//dbContext.performAndWait {
//    let request: NSFetchRequest<Day> = Day.fetchRequest()
//    request.predicate = NSPredicate(format: "dayId = %@", dayId)
//    request.fetchLimit = 1
//    if let dayRecs = try? request.execute(), let dayRec = dayRecs.first, !dayRec.isDayOff {
//        prevDate = dayRec.endFeeding
//    }
//}

extension NSManagedObjectContext {
    
    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes to bring the given managed object context up to date.
    ///
    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
    /// - Throws: An error if anything went wrong executing the batch deletion.
//    dbContext.performAndWait {
//        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
//        fetchRequest.predicate = NSPredicate(format: "date < %@", NSDate())  //to delete all, use no predictae
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        try? dbContext.executeAndMergeChanges(using: batchDeleteRequest)
//    }
    
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}

