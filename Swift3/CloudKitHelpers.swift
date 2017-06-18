//
//  CloudKitHelpers.swift
//  TMShared
//
//  Created by Travis Ma on 6/25/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import Foundation
import CloudKit

func cloudKitFetchAll(_ recordType: String, predicate: NSPredicate?, sorts: [NSSortDescriptor]?, result: @escaping (_ records: [CKRecord]?, _ error: NSError?) -> Void){
    let pred = predicate == nil ? NSPredicate(format: "TRUEPREDICATE") : predicate!
    let cloudKitQuery = CKQuery(recordType: recordType, predicate: pred)
    cloudKitQuery.sortDescriptors = sorts
    var records = [CKRecord]()
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    func recurrentOperations(_ cursor: CKQueryCursor?){
        let recurrentOperation = CKQueryOperation(cursor: cursor!)
        recurrentOperation.recordFetchedBlock = { record in
            records.append(record)
        }
        recurrentOperation.queryCompletionBlock = { cursor, error in
            if error != nil {
                print("cloudKitFetchAll - error - \(error!)")
                result(nil, error as NSError?)
            } else {
                if cursor != nil {
                    print("cloudKitFetchAll - records \(records.count) - cursor \(cursor!.description)")
                    recurrentOperations(cursor!)
                } else {
                    result(records, nil)
                }
            }
        }
        publicDatabase.add(recurrentOperation)
    }
    // initial operation
    let initialOperation = CKQueryOperation(query: cloudKitQuery)
    initialOperation.recordFetchedBlock = { record in
        records.append(record)
    }
    initialOperation.queryCompletionBlock = { cursor, error in
        if error != nil {
            print("cloudKitFetchAll - error - \(error!)")
            result(nil, error as NSError?)
        } else {
            if cursor != nil {
                print("cloudKitFetchAll - records \(records.count) - cursor \(cursor!.description)")
                recurrentOperations(cursor!)
            } else {
                result(records, nil)
            }
        }
    }
    publicDatabase.add(initialOperation)
}

func referencesToRecordNames(references: CKRecordValue?) -> [String] {
    var recordNames = [String]()
    if let refs = references as? [CKReference] {
        for r in refs {
            recordNames.append(r.recordID.recordName)
        }
    }
    return recordNames
}

func recordToData(record: CKRecord) -> NSData {
    let archivedData = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: archivedData)
    archiver.requiresSecureCoding = true
    record.encodeSystemFields(with: archiver)
    archiver.finishEncoding()
    return archivedData
}

func dataToRecord(data: NSData) -> CKRecord? {
    let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
    unarchiver.requiresSecureCoding = true
    return CKRecord(coder: unarchiver)
}


func nullCheckInt(_ int: CKRecordValue?) -> Int {
    if let int = int as? Int {
        return int
    } else {
        return 0
    }
}

func nullCheckString(_ string: CKRecordValue?) -> String {
    if let s = string as? String {
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    } else {
        return ""
    }
}
