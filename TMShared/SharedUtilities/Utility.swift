//
//  Utility.swift
//  TMShared
//
//  Created by Travis Ma on 9/6/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import Foundation

let imagesPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/images/"

func formatCurrency(_ number: NSNumber?) -> String {
    let num = number ?? NSNumber(value: 0)
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: num)!
}

func formatPhone(_ phone: String?) -> String {
    guard let phone = phone else {
        return ""
    }
    if phone.isEmpty || phone.count < 10 {
        return phone
    }
    let formattedPhone = NSMutableString(string: phone)
    formattedPhone.insert("(", at: 0)
    formattedPhone.insert(") ", at: 4)
    formattedPhone.insert("-", at: 9)
    return formattedPhone as String
}

func formatCurrency(_ number: Float?) -> String {
    let num = number ?? 0
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: num as NSNumber)!
}

func formatCurrency(_ number: Double?) -> String {
    let num = number ?? 0
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: num as NSNumber)!
}

func addCommas(_ int: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: int))!
}

func addCommas(_ number: NSNumber?) -> String {
    if number == nil {
        return "0"
    } else {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: number!)!
    }
}

struct Platform {
    static let isSimulator: Bool = {
        #if arch(i386) || arch(x86_64)
            return true
        #else
            return false
        #endif
    }()
}

func jsonDataToObject(_ data: Data?) -> Any? {
    guard let data = data else { return nil }
    do {
        return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    } catch {
        print("jsonDataToObject: \(error)")
    }
    return nil
}

func guid() -> String {
    return UUID().uuidString
}

func generatePasscode(_ length : Int) -> String {
    let letters : NSString = "1234567890"
    let randomString : NSMutableString = NSMutableString(capacity: length)
    for _ in 0 ..< length {
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    return randomString as String
}

func stringToDate(_ string: String, format: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: string)
}

func numberToBool(_ number: NSNumber?) -> Bool {
    if number == nil {
        return false
    } else {
        return number!.boolValue
    }
}

func nullCheckInt(_ int: Int?) -> Int {
    if int == nil {
        return 0
    } else {
        return int!
    }
}

func nullCheckString(_ string: String?) -> String {
    if string == nil {
        return ""
    } else {
        return string!
    }
}
