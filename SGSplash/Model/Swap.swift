//
//  Swap.swift
//  SGSplash
//
//  Created by Xian on 14/8/24.
//

import Foundation
struct Swap: CustomStringConvertible, Hashable {
    let elementA: Element
    let elementB: Element
    
    init(elementA: Element, elementB: Element) {
        self.elementA = elementA
        self.elementB = elementB
    }
    
    var description: String {
        return "Swap \(elementA) with \(elementB)"
    }
    
    // Compute a value that represents a swap, this will be stored in a set of allowable swaps
    func hash(into hasher: inout Hasher) {
           hasher.combine(elementA)
           hasher.combine(elementB)
       }
    
    // Operator overloading: compare two swaps
    static func ==(obj1: Swap, obj2: Swap) -> Bool {
        return (obj1.elementA == obj2.elementA && obj1.elementB == obj2.elementB) ||
        (obj1.elementB == obj2.elementA && obj1.elementA == obj2.elementB)
    }
}
