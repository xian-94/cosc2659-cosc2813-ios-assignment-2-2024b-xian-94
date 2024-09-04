/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Truong Hong Van
  ID: 3957034
  Created  date: 20/08/2024
  Last modified: 04/09/2024
  Acknowledgement:
 Colligan (2018) How to make a game like Candy Crush with SpriteKit: Part 1, Kodeco website, accessed 20/08/2024. https://www.kodeco.com/55-how-to-make-a-game-like-candy-crush-with-spritekit-and-swift-part-1
 Hacking with Swift website, accessed 20/08/2024. https://www.hackingwithswift.com/
 Pereira (2022) Using SpriteKit in a SwiftUI project, Create with Swift website, accessed 20/08/2024. https://www.createwithswift.com/using-spritekit-in-a-swiftui-project/#:~:text=Even%20though%20the%20default%20Game%20Xcode%20Template%20creates%20the%20project
 
*/

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

