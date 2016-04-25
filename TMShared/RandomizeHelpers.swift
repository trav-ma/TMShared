//
//  RandomizeHelpers.swift
//  MFOS
//
//  Created by Travis Ma on 11/5/15.
//  Copyright © 2015 Travis Ma. All rights reserved.
//

import UIKit

func randomNumber(length : Int) -> Int {
    let letters = "123456789"
    var randomString = ""
    for _ in 0 ..< length{
        let rand = Int(arc4random_uniform(UInt32(letters.characters.count)))
        randomString += "\(Array(letters.characters)[rand])"
    }
    return Int(randomString)!
}

func randomBool() -> Bool {
    return Int(arc4random_uniform(UInt32(2))) == 0
}

func randomPhone() -> String {
    return "(\(randomNumber(3))) \(randomNumber(3))-\(randomNumber(4))"
}

func randomName() -> String {
    let firstNames = [
        "Stephan",
        "Gregory",
        "Dorsey",
        "Mervin",
        "Demetrius",
        "Antonio",
        "Jamey",
        "Brian",
        "Shirley",
        "Gail",
        "Eugenio",
        "Chauncey",
        "Christian",
        "Xavier",
        "Terrance",
        "Spencer",
        "Collin",
        "Rashad",
        "Jude",
        "Tracey"
    ]
    let rand1 = Int(arc4random_uniform(UInt32(firstNames.count)))
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let rand2 = Int(arc4random_uniform(UInt32(letters.characters.count)))
    return "\(firstNames[rand1]) \(Array(letters.characters)[rand2])."
}

func randomChoice(array: [AnyObject]) -> AnyObject {
    return array[Int(arc4random_uniform(UInt32(array.count)))]
}

func diceRoll(i: Int) -> Int {
    return Int(arc4random_uniform(UInt32(i)) + 1)
}

func randomDate() -> NSDate { //random date within last week
    return dateAdjustedByDays(-(diceRoll(6)))
}