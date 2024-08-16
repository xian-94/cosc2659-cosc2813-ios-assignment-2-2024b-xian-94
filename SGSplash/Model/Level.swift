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
    var goal: Int
    var moves: Int
}

class Level {
    // Create a 2D array that holds the elements
    private var elements = Array2D<Element>(columns: columns, rows: rows)
    private var tiles = Array2D<Tile>(columns: columns, rows: rows)
    
    // Store the possible swaps in a level
    private var possibleSwaps: Set<Swap> = []
    
    // Constructor
    init(level: Int) {
        // Initialize tiles based on the level
        // The position of level 1 is index 0
        for (row, rowArray) in levels[level - 1].tiles.enumerated() {
            let tileRow = rows - row - 1
            for (column, value) in rowArray.enumerated() {
                // Create tiles for the 2D array positions whose value is 1, not 0
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
        
        // TODO: Add moves and goals for init later
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
}

