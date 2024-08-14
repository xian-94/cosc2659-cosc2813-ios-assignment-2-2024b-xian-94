//
//  Swap.swift
//  SGSplash
//
//  Created by Xian on 14/8/24.
//

import Foundation
struct Swap: CustomStringConvertible {
    let elementA: Element
    let elementB: Element
    
    init(elementA: Element, elementB: Element) {
        self.elementA = elementA
        self.elementB = elementB
    }
    
    var description: String {
        return "Swap \(elementA) with \(elementB)"
    }
}
