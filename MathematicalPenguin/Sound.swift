//
//  Sound.swift
//  MathematicalPenguin
//
//  Created by Stanislau Karaleuski on 17.02.2018.
//  Copyright © 2018 Stanislau Karaleuski. All rights reserved.
//

import Foundation
import AVFoundation

extension PlayViewController {
    
    func playSoundCorrectAnswer() {
        if userSettings.audio == 0 {
            do {
                self.player =  try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sound_1", ofType: "wav")!))
                self.player?.play()
            } catch {
                print("Error")
            }
        } else {
            print("Звук выключен")
        }
    }
    
}
