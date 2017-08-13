//
//  CloudKitHelpers.swift
//  TMShared
//
//  Created by Travis Ma on 6/25/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import Foundation
import CloudKit

func referencesToRecordNames(references: CKRecordValue?) -> String {
    var recordNames = [String]()
    if let refs = references as? [CKReference] {
        for r in refs {
            recordNames.append(r.recordID.recordName)
        }
    }
    return recordNames.joined(separator: ",")
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
