//
//  Double+Extensions.swift
//  Week Stock
//
//  Created by Travis Ma on 1/1/23.
//

import Foundation

extension Double {
    func percent(precision: Int = 2) -> String {
        return "\(self.formatted(.number.precision(.fractionLength(precision))))%"
    }
}
