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

func addCommas(toNumber number: NSNumber?) -> String {
    if number == nil {
        return "0"
    } else {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: number!)!
    }
}
