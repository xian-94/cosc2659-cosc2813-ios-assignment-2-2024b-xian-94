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

enum ChainType: CustomStringConvertible {
    case horizontal
    case vertical
    
    var description: String {
        switch self {
        case .horizontal: return "Horizontal"
        case .vertical: return "Vertical"
        }
    }
}

class Chain: Hashable, CustomStringConvertible {
    var elements: [Element] = []
    var type: ChainType
    var score = 0
    init(type: ChainType) {
        self.type = type
    }
    
    func add(element: Element) {
        elements.append(element)
    }
    
    func firstElement() -> Element {
        return elements[0]
    }
    
    func lastElement() -> Element {
        return elements[elements.count - 1]
    }
    
    var length: Int {
        return elements.count
    }
    
    var description: String {
        return "Type: \(type) elements: \(elements)"
    }
    
    func hash(into hasher: inout Hasher) {
        for e in elements {
            hasher.combine(e)
        }
    }
    
    static func == (obj1: Chain, obj2: Chain) -> Bool {
        return obj1.elements == obj2.elements
    }
    
}
