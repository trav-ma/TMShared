//
//  CloudKitHelpers.swift
//  TMShared
//
//  Created by Travis Ma on 6/25/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import Foundation
import CloudKit

func cloudKitFetchAll(recordType: String, predicate: NSPredicate?, sorts: [NSSortDescriptor]?, result: (records: [CKRecord]?, error: NSError?) -> Void){
    let pred = predicate == nil ? NSPredicate(format: "TRUEPREDICATE") : predicate!
    let cloudKitQuery = CKQuery(recordType: recordType, predicate: pred)
    cloudKitQuery.sortDescriptors = sorts
    var records = [CKRecord]()
    let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
    
    func recurrentOperations(cursor: CKQueryCursor?){
        let recurrentOperation = CKQueryOperation(cursor: cursor!)
        recurrentOperation.recordFetchedBlock = { record in
            records.append(record)
        }
        recurrentOperation.queryCompletionBlock = { cursor, error in
            if error != nil {
                print("cloudKitFetchAll - error - \(error)")
                result(records: nil, error: error)
            } else {
                if cursor != nil {
                    print("cloudKitFetchAll - records \(records.count) - cursor \(cursor!.description)")
                    recurrentOperations(cursor!)
                } else {
                    result(records: records, error: nil)
                }
            }
        }
        publicDatabase.addOperation(recurrentOperation)
    }
    // initial operation
    let initialOperation = CKQueryOperation(query: cloudKitQuery)
    initialOperation.recordFetchedBlock = { record in
        records.append(record)
    }
    initialOperation.queryCompletionBlock = { cursor, error in
        if error != nil {
            print("cloudKitFetchAll - error - \(error)")
            result(records: nil, error: error)
        } else {
            if cursor != nil {
                print("cloudKitFetchAll - records \(records.count) - cursor \(cursor!.description)")
                recurrentOperations(cursor!)
            } else {
                result(records: records, error: nil)
            }
        }
    }
    publicDatabase.addOperation(initialOperation)
}