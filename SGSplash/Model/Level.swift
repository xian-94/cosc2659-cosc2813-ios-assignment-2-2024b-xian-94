//
//  Level.swift
//  SGSplash
//
//  Created by Xian on 12/8/24.
//

import Foundation

let columns = 9
let rows = 9

// Struct to decode JSON file
struct LevelData: Codable {
    var number: Int
    var tiles: [[Int]]
    var target: String
    var quantity: Int
    var moves: Int
}

class Level {
    // Goal properties
    var target: ElementType
    var quantity: Int = 0
    var moves: Int = 0
    
    // Create a 2D array that holds the elements
    private var elements = Array2D<Element>(columns: columns, rows: rows)
    private var tiles = Array2D<Tile>(columns: columns, rows: rows)
    
    // Store the possible swaps in a level
    private var possibleSwaps: Set<Swap> = []
    
    // Constructor
    init(level: LevelData) {
        self.target = ElementType.getType(name: level.target)
        self.quantity = level.quantity
        self.moves = level.moves
        
        // Initialize tiles based on the level, the position of level 1 is index 0
        for (row, rowArray) in levels[level.number - 1].tiles.enumerated() {
            let tileRow = rows - row - 1
            for (column, value) in rowArray.enumerated() {
                // Create tiles for the 2D array positions whose value is 1, not 0
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
    }
    
    // Get a element based on position
    func elementAt(atColumn column: Int, row: Int) -> Element? {
        if column >= 0 && column < columns && row >= 0 && row < rows {
            return elements[column, row]
        }
        return nil
    }
    
    // Get the tile based on position
    func tileAt(column: Int, row: Int) -> Tile? {
        if column >= 0 && column < columns && row >= 0 && row < rows {
            return tiles[column, row]
        }
        return nil
        
    }
    
    private func createInitialTiles() -> Set<Element> {
        // Use Set for unordered unique list of elements
        var set: Set<Element> = []
        for row in 0..<rows {
            for col in 0..<columns {
                
                if tiles[col, row] != nil {
                    
                    var type: ElementType
                    // Ensure that no element chain exists on the initial board
                    repeat {
                        type = ElementType.random()
                    }
                    while (col >= 2 &&
                           // Check the adjacent elements in a row
                           elements[col - 1, row]?.type == type &&
                           elements[col - 2, row]?.type == type) ||
                            // Check the adjacent elements in a column
                            (row >= 2 &&
                             elements[col, row - 1]?.type == type &&
                             elements[col, row - 2]?.type == type)
                            
                            // Add new tile to the array
                            let newTile = Element(column: col, row: row, type: type)
                            elements[col, row] = newTile
                            set.insert(newTile)
                }
            }
        }
        return set
    }
    
    /* Handle swapping element */
    
    // Handle swapping elements
    func doSwap(_ swap: Swap) {
        let colA = swap.elementA.column
        let rowA = swap.elementA.row
        let colB = swap.elementB.column
        let rowB = swap.elementB.row
        // Update the elements array
        elements[colA, rowA] = swap.elementB
        swap.elementB.column = colA
        swap.elementB.row = rowA
        elements[colB, rowB] = swap.elementA
        swap.elementA.column = colB
        swap.elementA.row = rowB
    }
    
    // Determine if an element is a part of the element chain
    private func hasChain(atColumn column: Int, row: Int) -> Bool {
        let type = elements[column, row]?.type
        // Check horizontal chain
        var hChainLength = 1
        // On the left side
        var i = column - 1
        while i >= 0 && elements[i, row]?.type == type {
            i -= 1
            hChainLength += 1
        }
        // On the right side
        i = column + 1
        while i < columns && elements[i, row]?.type == type {
            i += 1
            hChainLength += 1
        }
        // Chain of 3 elements or above is valid
        if hChainLength >= 3 {
            return true
        }
        
        // Check vertical chain
        var vChainLength = 1
        // Chain from the element to below
        i = row - 1
        while i >= 0 && elements[column, i]?.type == type {
            i -= 1
            vChainLength += 1
        }
        // Chain from the element to above
        i = row + 1
        while i < rows && elements[column, i]?.type == type {
            i += 1
            vChainLength += 1
        }
        return vChainLength >= 3
    }
    
    // TODO: BUG can only swipe right to left and down to up
    // Detect possible swaps in a board of a level
    func detectPossibleSwaps() {
        var set: Set<Swap> = []
        for r in 0..<rows {
            for col in 0..<columns {
                if let e = elements[col, r] {
                    // Try swapping the element horizontally
                    if col < columns - 1, let e2 = elements[col + 1, r] {
                        elements[col, r] = e2
                        elements[col + 1, r] = e
                        // See if either element is a part of a chain
                        if hasChain(atColumn: col + 1, row: r) || hasChain(atColumn: col, row: r) {
                            // Swap either way
                            set.insert(Swap(elementA: e, elementB: e2))
                        }
                        // Swap back
                        elements[col, r] = e
                        elements[col + 1, r] = e2
                    }
                    // Try swapping the elment vertically
                    if r < rows - 1, let e2 = elements[col, r + 1] {
                        elements[col, r] = e2
                        elements[col, r + 1] = e
                        if hasChain(atColumn: col, row: r + 1) || hasChain(atColumn: col, row: r) {
                            set.insert(Swap(elementA: e, elementB: e2))
                        }
                        elements[col, r] = e
                        elements[col, r + 1] = e2
                    }
                }
                // Try swapping vertically in the last column
                else if col == columns - 1, let e = elements[col, r] {
                    if r < rows - 1,
                       let e2 = elements[col, r + 1] {
                        elements[col, r] = e2
                        elements[col, r + 1] = e
                        if hasChain(atColumn: col, row: r + 1) ||
                            hasChain(atColumn: col, row: r) {
                            set.insert(Swap(elementA: e, elementB: e2))
                        }
                        elements[col, r] = e
                        elements[col, r + 1] = e2
                    }
                }
            }
            possibleSwaps = set
        }
    }
    
    func shuffle() -> Set<Element> {
        var set: Set<Element>
        repeat {
            set = createInitialTiles()
            detectPossibleSwaps()
            print("Possible swaps: \(possibleSwaps)")
        } while possibleSwaps.count == 0
        
        return set
    }
    
    // Check possible swaps
    func isPossibleSwap(_ swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    /* Handle finding and removing matching elements */
    
    // Find horitontal chain
    private func findHorizontalChains() -> Set<Chain> {
        var set: Set<Chain> = []
        for r in 0..<numRows {
            var col = 0
            while col < numColumns-2 {
                if let e = elements[col, r] {
                    let matchType = e.type
                    // Find the chain
                    if elements[col + 1, r]?.type == matchType &&
                        elements[col + 2, r]?.type == matchType {
                        // Create a chain obj if chain is detected
                        let chain = Chain(type: .horizontal)
                        repeat {
                            // Add elements until no matching type is detected
                            chain.add(element: elements[col, r]!)
                            col += 1
                        }
                        while col < numColumns && elements[col, r]?.type == matchType
                                set.insert(chain)
                                continue
                    }
                }
                col += 1
            }
        }
        return set
    }
    
    // Detect vertical chain
    private func findVerticalChains() -> Set<Chain> {
        var set: Set<Chain> = []
        for col in 0..<numColumns {
            var r = 0
            while r < numRows-2 {
                if let e = elements[col, r] {
                    let matchType = e.type
                    // Find the chain
                    if elements[col, r + 1]?.type == matchType &&
                        elements[col, r + 2]?.type == matchType {
                        // Create a chain obj if chain is detected
                        let chain = Chain(type: .vertical)
                        repeat {
                            // Add elements until no matching type is detected
                            chain.add(element: elements[col, r]!)
                            r += 1
                        }
                        while r < numRows && elements[col, r]?.type == matchType
                                set.insert(chain)
                                continue
                    }
                }
                r += 1
            }
        }
        return set
    }
    
    // Find all the chains
    func findAllChains() -> Set<Chain> {
        let hChains = findHorizontalChains()
        let vChains = findVerticalChains()
        removeChains(in: hChains)
        removeChains(in: vChains)
        // Unite 2 sets of chains into 1 single set
        return hChains.union(vChains)
    }
    
    // Remove the chains
    private func removeChains(in chains: Set<Chain>) {
        for chain in chains {
            for e in chain.elements {
                elements[e.column, e.row] = nil
            }
        }
    }
    
    /* Handle dropping elements into empty holes */
    func fillHoles() -> [[Element]] {
        var columns: [[Element]] = []
        
        for column in 0..<numColumns {
            var arr: [Element] = []
            for row in 0..<numRows {
                // If a tile has no element
                if tiles[column, row] != nil && elements[column, row] == nil {
                    // Find the element that is right above the hole
                    for examinedRow in (row + 1)..<numRows {
                        if let element = elements[column, examinedRow] {
                            // Move the element to the hole
                            elements[column, examinedRow] = nil
                            elements[column, row] = element
                            element.row = row
                            arr.append(element)
                            break
                        }
                    }
                }
            }
            // Handle column which doesn't have hole
            if !arr.isEmpty {
                columns.append(arr)
            }
        }
        return columns
    }
    
    // Add new elements
    func topUpElements() -> [[Element]] {
        var columns: [[Element]] = []
        var lastType: ElementType = .unknown
        
        for col in 0..<numColumns {
            var arr: [Element] = []
            var r = numRows - 1
            while r >= 0 && elements[col, r] == nil {
                var newType: ElementType
                // The newly create element cannot have the same type with the last new element
                repeat {
                    newType = ElementType.random()
                } while newType == lastType
                lastType = newType
                
                // Create new element
                let newElement = Element(column: col, row: r, type: newType)
                elements[col, r] = newElement
                arr.append(newElement)
                r -= 1
                
            }
            if !arr.isEmpty {
                columns.append(arr)
            }
        }
        return columns
    }
    
    /* Level target management */
    func updateQuantity(for chains: Set<Chain>) -> Int {
        var reduction = 0
        for chain in chains {
            // Check if an element in the chain has the same type with the target
            if chain.elements[0].type == self.target {
                // Reduce the target quantity by the chain length
                reduction += chain.length
            }
        }
        return reduction
    }
    
    
}

