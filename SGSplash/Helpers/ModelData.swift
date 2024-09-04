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

func loadLevels(fileName: String) -> [LevelData] {
    if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
        if let data = try? Data(contentsOf: file) {
            do {
                let decoder = JSONDecoder()
                let decoded  = try decoder.decode([LevelData].self, from: data)
                return decoded
            }
            catch {
                fatalError("Failed to decode JSON: \(error)")
            }
        }
        else {
            fatalError("Couldn't load data from \(fileName)")
        }
    }
    else {
        fatalError("Couldn't find \(fileName) file in main bundle")
    }
    return []
}

// Import levels data
var easyLevels = loadLevels(fileName: "easy")
var medLevels = loadLevels(fileName: "medium")
var hardLevels = loadLevels(fileName: "hard")
var tutorial = loadLevels(fileName: "tutorial")
var easyAnimalLevels = loadLevels(fileName: "easy-animals")
var mediumAnimalLevels = loadLevels(fileName: "medium-animals")
var hardAnimalLevels = loadLevels(fileName: "hard-animals")

