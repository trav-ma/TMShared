//
//  Utility.swift
//  MFOS
//
//  Created by Travis Ma on 11/10/15.
//  Copyright © 2015 Travis Ma. All rights reserved.
//

import UIKit
import SystemConfiguration

let metersInMile = 1609.34

//MARK:- Classes

class StyledTextView: UITextView {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
        self.text = ""
        self.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 0)
    }
    
}

class StyledToggleButton: UIButton { //must be a "custom" button type
    var buttonId: String?
    
    override func awakeFromNib() {
        self.setImage(imageUnchecked, forState: .Normal)
        self.setImage(UIImage(named: "checked"), for: .selected)
        self.setTitleColor(UIColor.lightGray, for: UIControlState())
        self.setTitleColor(UIColor.gray, for: .selected)
        self.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        self.isHidden = true
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(" " + title!, for: state)
        self.isHidden = false
    }
    
}

class TableCellCollectionView: UICollectionView { //allows you to put a collectionview onto a table cell without disabling the cell selection
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            if hitView.isKind(of: TableCellCollectionView.self) {
                return nil
            } else {
                return hitView
            }
        } else {
            return nil
        }
    }
    
}

//MARK:- Network

func jsonDataToDictionary(_ data: Data) -> AnyObject? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    } catch let error {
        print("dataToJson: \(error)")
    }
    return nil
}

func dictionaryToJsonData(_ dic: NSDictionary) -> Data? {
    do {
        if JSONSerialization.isValidJSONObject(dic) {
            return try JSONSerialization.data(withJSONObject: dic, options: [])
        } else {
            print("modelToJson: Invalid JSON Object \(dic)")
        }
    } catch let error {
        print("modelToJson: \(error)")
    }
    return nil
}

func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
    }) else {
        return false
    }
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
}

//MARK:- Other Helpers

func generatePasscode(_ length : Int) -> NSString {
    let letters : NSString = "1234567890"
    let randomString : NSMutableString = NSMutableString(capacity: length)
    for _ in 0 ..< length {
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    return randomString
}

func formatPhone(_ phone: String?) -> String {
    if phone == nil || (phone!).characters.count == 0 {
        return ""
    }
    let stringts = NSMutableString()
    stringts.append(phone!)
    stringts.insert("(", at: 0)
    stringts.insert(") ", at: 4)
    stringts.insert("-", at: 9)
    return stringts as String
}

func colorGray(_ rgb: CGFloat) -> UIColor {
    return UIColor(red: rgb/255, green: rgb/255, blue: rgb/255, alpha: 1)
}

func appDelegate () -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

func toggleControlAccess(_ control: AnyObject, isEnabled: Bool) {
    if control.isKind(of: UITextField) {
        if let textField = control as? UITextField {
            textField.isEnabled = isEnabled
            textField.backgroundColor = !isEnabled ? colorGray(245) : UIColor.white
            textField.text = ""
        }
    } else if control.isKind(of: UITextView) {
        if let textView = control as? UITextView {
            textView.isEditable = isEnabled
            textView.backgroundColor = !isEnabled ? colorGray(245) : UIColor.white
            textView.text = ""
        }
    }
}

func listFontFamilies() {
    for family: String in UIFont.familyNames {
        print("\(family)")
        for names: String in UIFont.fontNames(forFamilyName: family) {
            print("== \(names)")
        }
    }
}

func lowercaseGuid() -> String {
    return NSUUID().uuidString.lowercased()
}

func formatCurrency(_ number: NSNumber?) -> String {
    if number == nil {
        return "$0.00"
    } else {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: number!)!
    }
}

public func deleteContentsOfFolder(_ dataPath: String) {
    if let enumerator = FileManager.default.enumerator(atPath: dataPath) {
        while let fileName = enumerator.nextObject() as? String {
            do {
                try FileManager.default.removeItem(atPath: "\(dataPath)\(fileName)")
            }
            catch let e as NSError {
                print(e)
            }
            catch {
                print("error")
            }
        }
    }
}

func numbersOnly(_ string: String?) -> String {
    if string == nil {
        return "0"
    }
    var s = string!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    if s.characters.count == 0 {
        s = "0"
    }
    return s
}

func nullCheck(_ string: String?) -> String {
    if string == nil {
        return ""
    } else {
        return string!
    }
}

func nullCheckBool(_ bool: NSNumber?) -> Bool {
    if bool == nil {
        return false
    } else {
        return bool!.boolValue
    }
}

func nullCheck(_ num: Int?) -> Int {
    if num == nil {
        return 0
    } else {
        return num!
    }
}

func nullCheck(_ num: Float?) -> Float {
    if num == nil {
        return 0
    } else {
        return num!
    }
}

func nullCheck(_ num: Double?) -> Double {
    if num == nil {
        return 0
    } else {
        return num!
    }
}

func nullCheck(_ date: Date?) -> Date {
    if date == nil {
        return Date()
    } else {
        return date!
    }
}

func nullCheck(_ num: NSNumber?) -> NSNumber {
    if num == nil {
        return NSNumber(value: 0 as Int)
    } else {
        return num!
    }
}

//MARK:- Date

func dateAdjustedByDays(_ date: Date, days: Int) -> Date {
    return (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: days, to: date, options: NSCalendar.Options(rawValue: 0))!
}

func formatDate(_ date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func isDateTimeInRange(_ timeStamp:Date, startTime:Date, endTime:Date) -> Bool {
    if (timeStamp as NSDate).earlierDate(endTime) == timeStamp && (timeStamp as NSDate).laterDate(startTime) == timeStamp{
        return true
    }
    return false
}

func dateAtTime(_ date: Date, hours: Int, minutes: Int) -> Date {
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    return (calendar as NSCalendar).date(bySettingHour: hours, minute: minutes, second: 0, of: date, options: NSCalendar.Options())!
}

func daysSinceDate(_ date: Date) -> Int {
    let components = (Calendar.current as NSCalendar).components([.day], from: date, to: Date(), options: [])
    return components.day!
}

//MARK:- Images

func scaleImage(_ image: UIImage, toSize newSize: CGSize) -> (UIImage) {
    let newRect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height).integral
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    let context = UIGraphicsGetCurrentContext()
    context!.interpolationQuality = .high
    let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
    context?.concatenate(flipVertical)
    context?.draw(image.cgImage!, in: newRect)
    let newImage = UIImage(cgImage: (context?.makeImage()!)!)
    UIGraphicsEndImageContext()
    return newImage
}

//Warning: converts transparencies to black
func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}


