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
