//
//  Tile.swift
//  SGSplash
//
//  Created by Xian on 12/8/24.
//

import Foundation
import SpriteKit


// TODO: Change the number of cases
enum ElementType: Int {
    case unknown = 0,
         banhxeo,
         banhcom,
         banhmi,
         banhcam,
         bbq,
         banhchung,
         banhdauxanh,
         springroll,
         banhdabo,
         roll
    
    // Find the image name of the tile
    func spriteName() -> String {
        // Names match the order of the declared case
        // Server for random tile purpose
        let spriteNames = [
            "banhxeo",
            "banhcom",
            "banhmi",
            "banhcam",
            "bbq",
            "banhchung",
            "banhdauxanh",
            "springroll",
            "banhdabo",
            "roll"
        ]
        // Since the raw value is integer
        return spriteNames[rawValue - 1]
    }
    // TODO: Change case later
    static func getType(name: String) -> ElementType {
        switch name.lowercased() {
        case "bbq":
            return .bbq
        default:
            return .unknown
        }
        
    }
    
    
    // Randomize the tile type for the newly added tile
    static func random() -> ElementType {
        return ElementType(rawValue: Int.random(in: 1...7))!
    }
}

// MARK: - Element
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
