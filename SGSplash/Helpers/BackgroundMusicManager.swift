//
//  BackgroundMusicManager.swift
//  SGSplash
//
//  Created by Xian on 26/8/24.
//

import Foundation
import SwiftUI
import AVFoundation

// Manage the background music
class BackgroundMusicManager {
    static let shared = BackgroundMusicManager()
    private var audioPlayer: AVAudioPlayer?
    
    // Ensure only 1 instance is instantiated
    private init() {
    }
    
    func start() {
        if let soundURL = Bundle.main.url(forResource: "background-music", withExtension: "mp3") {
            print(soundURL)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                // Ensure the audio loops
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } catch {
                print("Error playing background music: \(error)")
            }
        }
    }
    
    func stop() {
        audioPlayer?.stop()
    }
}

