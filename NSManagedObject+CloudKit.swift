//
//  NSManagedObject+extension.swift
//  jaunt
//
//  Created by Travis Ma on 6/28/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

extension NSManagedObject {
    //in core data only use doubles, strings, dates, bools and int64
    //replicate the fields and entity names from CloudKit exactly
    //must have a systemFields Binary data field (CoreData Only)
    //must have a needsSync bool (CoreData Only)
    
    func cloudKitRecord() -> CKRecord {
        var record: CKRecord!
        if let systemFields = self.value(forKey: "systemFields") as? NSData {
            record = dataToRecord(data: systemFields)
        } else {
            record = CKRecord(recordType: self.entity.name ?? "")
        }
        for (field, attribute) in self.entity.attributesByName {
            if ["systemFields", "needsSync"].contains(field) {
                continue
            }
            switch attribute.attributeType {
            case .integer64AttributeType:
                record[field] = self.value(forKey: field) as? Int64
            case .doubleAttributeType:
                record[field] = self.value(forKey: field) as? Double
            case .stringAttributeType:
                record[field] = self.value(forKey: field) as? String
            case .booleanAttributeType:
                record[field] = self.value(forKey: field) as? Bool
            case .dateAttributeType:
                record[field] = self.value(forKey: field) as? NSDate
            default:
                break
            }
        }
        return record
    }
    
    class func upsertCloudKitRecord(record: CKRecord, inContext context: NSManagedObjectContext) {
        guard let ckuid = record["uid"] as? String else {
            return
        }
        context.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: record.recordType)
            request.predicate = NSPredicate(format: "uid = %@", ckuid)
            var object = try? context.fetch(request).first as? NSManagedObject
            if object == nil {
                let entity = NSEntityDescription.entity(forEntityName: record.recordType, in: context)!
                object = NSManagedObject(entity: entity, insertInto: context)
            }
            if let object = object {
                for (field, attribute) in object.entity.attributesByName {
                    if field == "systemFields" {
                        object.setValue(recordToData(record: record), forKey: field)
                        continue
                    }
                    if field == "needsSync" {
                        object.setValue(false, forKey: field)
                        continue
                    }
                    switch attribute.attributeType {
                    case .integer64AttributeType:
                        object.setValue(record[field] as? Int64, forKey: field)
                    case .doubleAttributeType:
                        object.setValue(record[field] as? Double, forKey: field)
                    case .stringAttributeType:
                        object.setValue(record[field] as? String, forKey: field)
                    case .booleanAttributeType:
                        object.setValue(record[field] as? Bool ?? false, forKey: field)
                    case .dateAttributeType:
                        object.setValue(record[field] as? NSDate, forKey: field)
                    default:
                        break
                    }
                }
            }
        }
    }
    
}
