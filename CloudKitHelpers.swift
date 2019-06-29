//
//  CloudKitHelpers.swift
//  TMShared
//
//  Created by Travis Ma on 6/25/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import UIKit
import CloudKit

func referencesToRecordNames(references: CKRecordValue?) -> String {
    var recordNames = [String]()
    if let refs = references as? [CKRecord.Reference] {
        for r in refs {
            recordNames.append(r.recordID.recordName)
        }
    }
    return recordNames.joined(separator: ",")
}

func referencesToRecordNamesArray(references: CKRecordValue?) -> [String] {
    var recordNames = [String]()
    if let refs = references as? [CKRecord.Reference] {
        for r in refs {
            recordNames.append(r.recordID.recordName)
        }
    }
    return recordNames
}

func recordToData(record: CKRecord) -> NSData {
    let coder = NSKeyedArchiver(requiringSecureCoding: true)
    record.encodeSystemFields(with: coder)
    return coder.encodedData as NSData
}

func dataToRecord(data: NSData) -> CKRecord? {
    let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data as Data)
    unarchiver?.requiresSecureCoding = true
    return unarchiver == nil ? nil : CKRecord(coder: unarchiver!)
}

func ckErrorMessage(error: Error) -> String {
    var errorMessage = error.localizedDescription
    if let error = error as? CKError {
        if let msg = (error.errorUserInfo[NSUnderlyingErrorKey] as? NSError)?.localizedDescription {
            errorMessage = msg
        }
        switch error.code {
        case .serverRecordChanged, .changeTokenExpired:
            errorMessage = "Looks like the data on your device is too old to update. Please do a refresh and try again."
        default:
            break
        }
    }
    return errorMessage
}

func showCKError(currentViewController: UIViewController, error: Error) {
    let errorMessage = ckErrorMessage(error: error)
    DispatchQueue.main.async(execute:{
        let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        currentViewController.present(alert, animated: true, completion: nil)
    })
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

func createCloudKitAsset(from data: Data) -> CKAsset? {
    var returnAsset: CKAsset? = nil
    let tempStr = ProcessInfo.processInfo.globallyUniqueString
    let filename = "\(tempStr)_file.bin"
    let baseURL = URL(fileURLWithPath: NSTemporaryDirectory())
    let fileURL = baseURL.appendingPathComponent(filename, isDirectory: false)
    do {
        try data.write(to: fileURL, options: [.atomicWrite])
        returnAsset = CKAsset(fileURL: fileURL)
    } catch {
        print("Error creating asset: \(error)")
    }
    return returnAsset
    
}
