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

//styles

class StyledTextView: UITextView {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
        self.text = ""
        self.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 0)
    }
    
}

class StyledToggleButton: UIButton { //must be a "custom" button type
    var buttonId: String?
    
    override func awakeFromNib() {
        self.setImage(UIImage(named: "unchecked"), forState: .Normal)
        self.setImage(UIImage(named: "checked"), forState: .Selected)
        self.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.setTitleColor(UIColor.grayColor(), forState: .Selected)
        self.titleLabel!.font = UIFont.systemFontOfSize(15)
        self.hidden = true
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(" " + title!, forState: state)
        self.hidden = false
    }
    
}

//Helpers

class TableCellCollectionView: UICollectionView { //allows you to put a collectionview onto a table cell without disabling the cell selection
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)!
        if hitView.isKindOfClass(TableCellCollectionView) {
            return nil
        } else {
            return hitView
        }
    }
    
}

func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
        SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
    }) else {
        return false
    }
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    let isReachable = flags.contains(.Reachable)
    let needsConnection = flags.contains(.ConnectionRequired)
    return (isReachable && !needsConnection)
}

func appDelegate () -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
}

func dateAdjustedByDays(days: Int) -> NSDate {
    return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: days, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))!
}

func toggleControlAccess(control: AnyObject, isEnabled: Bool) {
    if control.isKindOfClass(UITextField) {
        if let textField = control as? UITextField {
            textField.enabled = isEnabled
            textField.backgroundColor = !isEnabled ? colorGray(245) : UIColor.whiteColor()
            textField.text = ""
        }
    } else if control.isKindOfClass(UITextView) {
        if let textView = control as? UITextView {
            textView.editable = isEnabled
            textView.backgroundColor = !isEnabled ? colorGray(245) : UIColor.whiteColor()
            textView.text = ""
        }
    }
}

func listFontFamilies() {
	for family: String in UIFont.familyNames() {
	     print("\(family)")
	     for names: String in UIFont.fontNamesForFamilyName(family) {
	         print("== \(names)")
	     }
	}
}

func scaleImage(image: UIImage, toSize newSize: CGSize) -> (UIImage) {
    let newRect = CGRectIntegral(CGRectMake(0,0, newSize.width, newSize.height))
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    let context = UIGraphicsGetCurrentContext()
    CGContextSetInterpolationQuality(context, .High)
    let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
    CGContextConcatCTM(context, flipVertical)
    CGContextDrawImage(context, newRect, image.CGImage)
    let newImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
    UIGraphicsEndImageContext()
    return newImage
}

//converts transparencies to black
func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
    image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}

func lastPartOfGuid(guid: String) -> String {
    if let idx = guid.rangeOfString("-", options: .BackwardsSearch)?.startIndex {
        return guid.substringFromIndex(idx.advancedBy(1))
    } else {
        return "-"
    }
}

func lowercaseGuid() -> String {
    return NSUUID().UUIDString.lowercaseString
}

func jsonDataToDictionary(data: NSData) -> AnyObject? {
    do {
        return try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
    } catch let error {
        print("dataToJson: \(error)")
    }
    return nil
}

func dictionaryToJsonData(dic: NSDictionary) -> NSData? {
    do {
        if NSJSONSerialization.isValidJSONObject(dic) {
            return try NSJSONSerialization.dataWithJSONObject(dic, options: [])
        } else {
            print("modelToJson: Invalid JSON Object \(dic)")
        }
    } catch let error {
        print("modelToJson: \(error)")
    }
    return nil
}

func colorGray(rgb: CGFloat) -> UIColor {
    return UIColor(red: rgb/255, green: rgb/255, blue: rgb/255, alpha: 1)
}

func formatDate(date: NSDate, format: String) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.stringFromDate(date)
}

func formatCurrency(number: NSNumber) -> String {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    return formatter.stringFromNumber(number)!
}

func isDateTimeInRange(timeStamp:NSDate, startTime:NSDate, endTime:NSDate)->Bool{
    if timeStamp.earlierDate(endTime) == timeStamp && timeStamp.laterDate(startTime) == timeStamp{
        return true
    }
    return false
}

public func deleteContentsOfFolder(dataPath: String) {
    if let enumerator = NSFileManager.defaultManager().enumeratorAtPath(dataPath) {
        while let fileName = enumerator.nextObject() as? String {
            do {
                try NSFileManager.defaultManager().removeItemAtPath("\(dataPath)\(fileName)")
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

func currentDateAtTime(hours: Int, minutes: Int) -> NSDate {
    let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    return cal.dateBySettingHour(hours, minute: minutes, second: 0, ofDate: NSDate(), options: NSCalendarOptions())!
}

func numbersOnly(string: String?) -> String {
    if string == nil {
        return "0"
    }
    var s = string!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
    if s.characters.count == 0 {
        s = "0"
    }
    return s
}

func nullCheck(string: String?) -> String {
    if string == nil {
        return ""
    } else {
        return string!
    }
}

func nullCheckBool(bool: NSNumber?) -> Bool {
    if bool == nil {
        return false
    } else {
        return bool!.boolValue
    }
}

func nullCheck(num: NSNumber?) -> NSNumber {
    if num == nil {
        return NSNumber(integer: 0)
    } else {
        return num!
    }
}


