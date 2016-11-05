//
//  Utility.swift
//  TMShared
//
//  Created by Travis Ma on 9/6/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import UIKit

let imagesPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/images/"

func formatCurrency(number: NSNumber?) -> String {
    if number == nil {
        return "$0.00"
    } else {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: number!)!
    }
}

func addCommas(toInt int: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: int))!
}

func addCommas(toNumber number: NSNumber?) -> String {
    if number == nil {
        return "0"
    } else {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: number!)!
    }
}

func colorGray(_ rgb: CGFloat) -> UIColor {
    return UIColor(red: rgb/255, green: rgb/255, blue: rgb/255, alpha: 1)
}

func phoneSizeInInches(defaultValue: Float = 4.7) -> Float {
    switch (UIScreen.main.nativeBounds.size.height) {
    case 960, 480:
        return 3.5
    case 1136:
        return 4
    case 1334:
        return 4.7
    case 2208:
        return 5.5
    default:
        return defaultValue
    }
}

func dateAtTime(date: Date, hours: Int, minutes: Int) -> Date {
    let calendar = Calendar(identifier: .gregorian)
    var hrs = hours
    var mins = minutes
    var d = date
    if minutes > 60 {
        hrs += Int(floor(Double(minutes) / 60))
        mins = Int(Double(minutes).truncatingRemainder(dividingBy: 60))
    }
    if hrs > 24 {
        let days = Int(floor(Double(hrs) / 24))
        hrs = Int(Double(hrs).truncatingRemainder(dividingBy: 24))
        d = calendar.date(byAdding: .day, value: days, to: date)!
    }
    if hrs == 24 {
        hrs = 23
        mins = 59
    }
    return calendar.date(bySettingHour: hrs, minute: mins, second: 0, of: d)!
}

func dayOfWeek(_ date: Date) -> Int {
    let cal = Calendar(identifier: .gregorian)
    return cal.component(.weekday, from: date)
}

func formatDate(_ date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func numberToBool(_ number: NSNumber?) -> Bool {
    if number == nil {
        return false
    } else {
        return number!.boolValue
    }
}

func dateWithZeroSeconds(_ date: Date) -> Date {
    let time = floor(date.timeIntervalSinceReferenceDate / 60) * 60
    return Date(timeIntervalSinceReferenceDate: time)
}

func nullCheckString(_ string: String?) -> String {
    if string == nil {
        return ""
    } else {
        return string!
    }
}

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}

//usage animateShakes(view: myTextField, shakes: 0, direction: 1)
func animateShakes(view: UIView, shakes: Int, direction: Int) {
    var s = shakes
    var d = direction
    UIView.animate(withDuration: 0.05, animations: {
        view.transform = CGAffineTransform(translationX: CGFloat(5 * direction), y: 0)
        }, completion: {
            finished in
            if shakes >= 8 {
                view.transform = .identity
                return
            }
            s += 1
            d = d * -1
            animateShakes(view: view, shakes: s, direction: d)
    })
}
