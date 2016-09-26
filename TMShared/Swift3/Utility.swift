//
//  Utility.swift
//  TMShared
//
//  Created by Travis Ma on 9/6/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import UIKit

func formatCurrency(number: NSNumber?) -> String {
    if number == nil {
        return "$0.00"
    } else {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: number!)!
    }
}

func addCommas(toInt16 int: Int16) -> String {
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

func formatDate(_ date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
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
