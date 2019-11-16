//
//  PropertyWrappers.swift
//  jaunt
//
//  Created by Travis Ma on 11/3/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import Foundation

/*
 enum GlobalSettings {
   @UserDefault("BeenHereBefore", defaultValue: false)
   static var beenHereBefore: Bool
   @UserDefault("TopScore", defaultValue: 0)
   static var topScore: Int
   @UserDefault("UserName", defaultValue: "Anon")
   static var userName: String
 }
 
 or
 
 struct GlobalSettings {
   @UserDefault("BeenHereBefore", defaultValue: false)
   static var beenHereBefore: Bool
   @UserDefault("TopScore", defaultValue: 0)
   static var topScore: Int
   @UserDefault("UserName", defaultValue: "Anon")
   static var userName: String
 }
 */

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
