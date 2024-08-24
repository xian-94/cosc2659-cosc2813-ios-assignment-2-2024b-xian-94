//
//  SoundEffect.swift
//  SGSplash
//
//  Created by Xian on 24/8/24.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

// Helper function to play sound effect in SwiftUI
func playSound(name: String, type: String) {
    if let soundPath = Bundle.main.url(forResource: name, withExtension: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundPath)
            audioPlayer?.play()
        }
        catch {
            print("Failed to load the sound file!")
        }
    }
}

