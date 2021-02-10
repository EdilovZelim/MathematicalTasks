//
//  UserSettings.swift
//  MathematicalPenguin
//
//  Created by Stanislau Karaleuski on 06.02.2018.
//  Copyright © 2018 Stanislau Karaleuski. All rights reserved.
//

import Foundation

let defaults = UserDefaults.standard

struct UserSettings {
    
    var reward = defaults.integer(forKey: "reward")
    var startApp = defaults.integer(forKey: "startApp")
    var audio = defaults.integer(forKey: "audio")
    
    func saveUserSettings() {
        defaults.set(reward, forKey: "reward")
        defaults.set(startApp, forKey: "startApp")
        defaults.set(audio, forKey: "audio")
        defaults.synchronize()
    }
    
    mutating func loadUserSettings() {
        reward = defaults.integer(forKey: "reward")
        startApp = defaults.integer(forKey: "startApp")
        audio = defaults.integer(forKey: "audio")
    }
    
    mutating func setStartApp() {
        startApp += 1
        saveUserSettings()
    }
    
    func printUserSettings () {
        print("reward = \(reward)")
        print("StartApp = \(startApp)")
        print("audio = \(audio)")
    }
    
}
