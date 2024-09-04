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
import SpriteKit


enum ElementType: Int, Codable {
    case unknown = 0,
         apple,
         bread,
         coconut,
         flower,
         veggie,
         milk,
         orange,
         rabbit,
         lamb,
         chick,
         pig,
         buffalo,
         cow,
         chicken
    
    
    // Find the image name of the tile
    func spriteName() -> String {
        // Names match the order of the declared case
        // Server for random tile purpose
        let spriteNames = [
            "apple",
            "bread",
            "coconut",
            "flower",
            "veggie",
            "milk",
            "orange",
            "rabbit",
            "lamb",
            "pig",
            "chick",
            "buffalo",
            "cow",
            "chicken"
        ]
        // Since the raw value is integer
        return spriteNames[rawValue - 1]
    }
    static func getType(name: String) -> ElementType {
        switch name.lowercased() {
        case "apple":
            return .apple
        case "bread":
            return .bread
        case "coconut":
            return .coconut
        case "flower":
            return .flower
        case "veggie":
            return .veggie
        case "milk":
            return .milk
        case "orange":
            return .orange
        case "rabbit":
            return .rabbit
        case "lamb":
            return .lamb
        case "chick":
            return .chick
        case "pig":
            return .pig
        case "buffalo":
            return .buffalo
        case "cow":
            return .cow
        case "chicken":
            return .chicken
        default:
            return .unknown
        }
        
    }
    
    
    // Randomize the tile type for the newly added tile, character set 1
    static func random1() -> ElementType {
        return ElementType(rawValue: Int.random(in: 1...7))!
    }
    
    // Randomize the tile type for the newly added tile, character set 2
    static func random2() -> ElementType {
        return ElementType(rawValue: Int.random(in: 8...13))!
    }
    
    
}

// MARK: Element
class Element: CustomStringConvertible, Hashable {
    
    // 2D position of the tile
    var column: Int
    var row: Int
    let type: ElementType
    var sprite: SKSpriteNode?
    
    // Constructor
    init(column: Int, row: Int, type: ElementType) {
        self.column = column
        self.row = row
        self.type = type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(column)
        hasher.combine(row)
    }
    
    // Override == operator to compare the position of two tiles
    static func == (obj1: Element, obj2: Element) -> Bool {
        return obj1.column == obj2.column && obj1.row == obj2.row
    }
    
    var description: String {
        return "type: \(self.type) square: (\(self.column), \(self.row))"
    }
    
    
}
