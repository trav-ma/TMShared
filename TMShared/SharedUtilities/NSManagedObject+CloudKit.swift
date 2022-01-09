//
//  NSManagedObject+extension.swift
//  jaunt
//
//  Created by Travis Ma on 6/28/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

extension NSManagedObject {
    //in core data only use doubles, strings, dates, bools and int64
    
    //replicate the fields and entity names from CloudKit EXACTLY
    
    //must have a systemFields Binary data field (CoreData Only)
    
    //must have a needsSync bool (CoreData Only) - Default value = false
    
    //recommended isOfflineDeleted field in both CoreData (Default value = false) + CloudKit
    
    //recommended uid String field in both CoreData + CloudKit for guid id + relations
    
    //NOTE: if you set something to nil, it will not sync down from CloudKit, this is because when we alter DB (add fields) and add default values (in core data, since CloudKit doesn't support default values), those will be set to nil on initial sync... if CloudKit supports default values we can change this to sync down nils
    
    //CloudKit DB tables should have "modifiedByDeviceIdentifier" String (Queryable). CoreData shouldn't have this field
    //This field is so that when you push changes to CloudKit, you can skip syncing those same changes down later by requesting records where modifiedByDeviceIdentifier doesn't match your id
    
    //Cloudkit DB should have "modifiedAt" set to Queryable
    
    func cloudKitRecord(deviceId: String? = nil) -> CKRecord {
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
                record[field] = self.value(forKey: field) as? Date
            default:
                break
            }
        }
        if deviceId != nil {
            record["modifiedByDeviceIdentifier"] = deviceId!
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
            request.fetchLimit = 1
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
                    if field == "modifiedByDeviceIdentifier" {
                        continue
                    }
                    switch attribute.attributeType {
                    case .integer64AttributeType:
                        if let value = record[field] as? Int64 { //if it's not nil, we'll sync it down, see old version to sync down nils
                            object.setValue(value, forKey: field)
                        }
                    case .doubleAttributeType:
                        if let value = record[field] as? Double {
                            object.setValue(value, forKey: field)
                        }
                    case .stringAttributeType:
                        if let value = record[field] as? String {
                            object.setValue(value, forKey: field)
                        }
                    case .booleanAttributeType:
                        if let value = record[field] as? Bool {
                            object.setValue(value, forKey: field)
                        }
                    case .dateAttributeType:
                        if let value = record[field] as? Date {
                            object.setValue(value, forKey: field)
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
}
