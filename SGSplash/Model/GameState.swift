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
struct GameState: Codable {
    var level: Int
    var score: Int
    var movesLeft: Int
    var goals: [Goal]
    var timeRemaining: Int
    var elements: [[ElementType?]]
    init(level: Int = 1, score: Int = 0, movesLeft: Int = 0, goals: [Goal] = [], timeRemaining: Int = 0, elements: [[ElementType?]]) {
        self.level = level
        self.score = score
        self.movesLeft = movesLeft
        self.goals = goals
        self.timeRemaining = timeRemaining
        self.elements = elements
    }
}

