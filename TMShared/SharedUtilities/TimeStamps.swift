//
//  TimeStamps.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import Foundation

var timestamps = [String: Date]()

func startTimestamp(_ name: String) {
    let date = Date()
    timestamps[name] = date
    print("TIMESTAMP START \(name) = \(date)")
}

func endTimestamp(_ name: String) {
    let date = Date()
    if let startDate = timestamps[name] {
        timestamps.removeValue(forKey: name)
        print("TIMESTAMP END \(name) - \(date)")
        print("TIMESTAMP ELAPSED TIME \(name) - \(date.timeIntervalSince(startDate).stringTime)")
    } else {
        print("TIMESTAMP END \(name) - Doesn't exist")
    }
}
