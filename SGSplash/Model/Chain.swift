//
//  Chain.swift
//  SGSplash
//
//  Created by Xian on 16/8/24.
//

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
