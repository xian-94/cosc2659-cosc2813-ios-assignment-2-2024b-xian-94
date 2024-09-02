//
//  Level.swift
//  SGSplash
//
//  Created by Xian on 12/8/24.
//

import Foundation

// Struct to decode JSON file
struct LevelData: Codable {
    var number: Int
    var columns: Int
    var rows: Int
    var tiles: [[Int]]
    var goals: [Goal]
    var moves: Int
    // For hard mode
    var timeLimit: Int?
    
    static func getLevelPack(for mode: String) -> [LevelData] {
        // Set the level with chosen mode
        switch mode {
        case "easy":
            return easyLevels
        case "medium":
            return medLevels
        case "hard":
            return hardLevels
        case "tutorial":
            return tutorial
        default:
            return []
        }
    }
}

class Level {
    
    // Goal properties
    var number: Int = 0
    var moves: Int = 0
    
    var goals: [Goal] = []
    // Count the number of chain combos
    private var combo = 0
    // For hard mode
    var timeLimit: Int?
    
    // Tile properties
    var columns: Int
    var rows: Int
    
    // Create a 2D array that holds the elements
    var elements: [[Element?]]
    private var tiles: [[Tile?]]
    
    // Store the possible swaps in a level
    private var possibleSwaps: Set<Swap> = []
    
    // Constructor
    init(levelPack: [LevelData], levelNumber: Int) {
        self.number = levelPack[levelNumber].number
        self.moves = levelPack[levelNumber].moves
        self.columns = levelPack[levelNumber].columns
        self.rows = levelPack[levelNumber].rows
        self.goals = levelPack[levelNumber].goals
        self.combo = 0
        self.timeLimit = levelPack[levelNumber].timeLimit
        self.elements = Array(repeating: Array(repeating: nil, count: self.rows), count: self.columns)
        self.tiles = Array(repeating: Array(repeating: nil, count: self.rows), count: self.columns)
        // Initialize tiles based on the level, the position of level 1 is index 0
        for (row, rowArray) in levelPack[self.number - 1].tiles.enumerated() {
            let tileRow = self.rows - row - 1
            for (column, value) in rowArray.enumerated() {
                // Create tiles for the 2D array positions whose value is 1, not 0
                if value == 1 {
                    tiles[column][tileRow] = Tile()
                }
            }
        }
    }
    
    func getElements() -> [[Element?]] {
        return self.elements
    }
    
    func getElementTypes() -> [[ElementType?]] {
        return self.elements.map { row in
            row.map { element in
                element?.type
            }
        }
    }
    
    // Helper for save and resume, set the level elements as the current saved elements' positions
    func setElements(_ elements: [[Element?]]) {
        self.elements = elements
        detectPossibleSwaps()
    }

    
    func getPossibleSwaps() -> Set<Swap> {
        return self.possibleSwaps
    }
    
    // Get a element based on position
    func elementAt(atColumn column: Int, row: Int) -> Element? {
        if column >= 0 && column < self.columns && row >= 0 && row < self.rows {
            return elements[column][row]
        }
        return nil
    }
    
    // Get the tile based on position
    func tileAt(column: Int, row: Int) -> Tile? {
        if column >= 0 && column < self.columns && row >= 0 && row < self.rows {
            return tiles[column][row]
        }
        return nil
        
    }
    
    private func createInitialTiles() -> Set<Element> {
        // Use Set for unordered unique list of elements
        var set: Set<Element> = []
        for row in 0..<self.rows {
            for col in 0..<self.columns {
                
                if tiles[col][row] != nil {
                    
                    var type: ElementType
                    // Ensure that no element chain exists on the initial board
                    repeat {
                        type = ElementType.random()
                    }
                    while (col >= 2 &&
                           // Check the adjacent elements in a row
                           elements[col - 1][row]?.type == type &&
                           elements[col - 2][row]?.type == type) ||
                            // Check the adjacent elements in a column
                            (row >= 2 &&
                             elements[col][row - 1]?.type == type &&
                             elements[col][row - 2]?.type == type)
                            
                            // Add new tile to the array
                            let newTile = Element(column: col, row: row, type: type)
                            elements[col][row] = newTile
                            set.insert(newTile)
                }
            }
        }
        return set
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
    
    // MARK: Handle swiping
    
    // Handle swapping elements
    func doSwap(_ swap: Swap) {
        let colA = swap.elementA.column
        let rowA = swap.elementA.row
        let colB = swap.elementB.column
        let rowB = swap.elementB.row
        // Update the elements array
        elements[colA][rowA] = swap.elementB
        swap.elementB.column = colA
        swap.elementB.row = rowA
        elements[colB][rowB] = swap.elementA
        swap.elementA.column = colB
        swap.elementA.row = rowB
    }
    
    // Determine if an element is a part of the element chain
    private func hasChain(atColumn column: Int, row: Int) -> Bool {
        let type = elements[column][row]?.type
        // Check horizontal chain
        var hChainLength = 1
        // On the left side
        var i = column - 1
        while i >= 0 && elements[i][row]?.type == type {
            i -= 1
            hChainLength += 1
        }
        // On the right side
        i = column + 1
        while i < columns && elements[i][row]?.type == type {
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
        while i >= 0 && elements[column][i]?.type == type {
            i -= 1
            vChainLength += 1
        }
        // Chain from the element to above
        i = row + 1
        while i < rows && elements[column][i]?.type == type {
            i += 1
            vChainLength += 1
        }
        return vChainLength >= 3
    }
    
    // Detect possible swaps in a board of a level
    func detectPossibleSwaps() {
        var set: Set<Swap> = []
        for r in 0..<rows {
            for col in 0..<columns {
                if let e = elements[col][r] {
                    // Try swapping the element horizontally
                    if col < columns - 1, let e2 = elements[col + 1][r] {
                        elements[col][r] = e2
                        elements[col + 1][r] = e
                        // See if either element is a part of a chain
                        if hasChain(atColumn: col + 1, row: r) || hasChain(atColumn: col, row: r) {
                            // Swap either way
                            set.insert(Swap(elementA: e, elementB: e2))
                        }
                        // Swap back
                        elements[col][r] = e
                        elements[col + 1][r] = e2
                    }
                    // Try swapping the elment vertically
                    if r < rows - 1, let e2 = elements[col][r + 1] {
                        elements[col][r] = e2
                        elements[col][r + 1] = e
                        if hasChain(atColumn: col, row: r + 1) || hasChain(atColumn: col, row: r) {
                            set.insert(Swap(elementA: e, elementB: e2))
                        }
                        elements[col][r] = e
                        elements[col][r + 1] = e2
                    }
                }
                // Try swapping vertically in the last column
                else if col == columns - 1, let e = elements[col][r] {
                    if r < rows - 1,
                       let e2 = elements[col][r + 1] {
                        elements[col][r] = e2
                        elements[col][r + 1] = e
                        if hasChain(atColumn: col, row: r + 1) ||
                            hasChain(atColumn: col, row: r) {
                            set.insert(Swap(elementA: e, elementB: e2))
                        }
                        elements[col][r] = e
                        elements[col][r + 1] = e2
                    }
                }
            }
            possibleSwaps = set
        }
    }
    
    
    // Check possible swaps
    func isPossibleSwap(_ swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    // MARK: Find and remove matching elements
    
    // Find horitontal chain
    private func findHorizontalChains() -> Set<Chain> {
        var set: Set<Chain> = []
        for r in 0..<self.rows {
            var col = 0
            while col < self.columns-2 {
                if let e = elements[col][r] {
                    let matchType = e.type
                    // Find the chain
                    if elements[col + 1][r]?.type == matchType &&
                        elements[col + 2][r]?.type == matchType {
                        // Create a chain obj if chain is detected
                        let chain = Chain(type: .horizontal)
                        repeat {
                            // Add elements until no matching type is detected
                            chain.add(element: elements[col][r]!)
                            col += 1
                        }
                        while col < self.columns && elements[col][r]?.type == matchType
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
        for col in 0..<self.columns {
            var r = 0
            while r < self.rows-2 {
                if let e = elements[col][r] {
                    let matchType = e.type
                    // Find the chain
                    if elements[col][r + 1]?.type == matchType &&
                        elements[col][r + 2]?.type == matchType {
                        // Create a chain obj if chain is detected
                        let chain = Chain(type: .vertical)
                        repeat {
                            // Add elements until no matching type is detected
                            chain.add(element: elements[col][r]!)
                            r += 1
                        }
                        while r < self.rows && elements[col][r]?.type == matchType
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
        
        // Calculate the scores
        calcScore(for: hChains)
        calcScore(for: vChains)
        // Unite 2 sets of chains into 1 single set
        return hChains.union(vChains)
    }
    
    // Remove the chains
    private func removeChains(in chains: Set<Chain>) {
        for chain in chains {
            for e in chain.elements {
                elements[e.column][e.row] = nil
            }
        }
    }
    
    // MARK: Fill empty holes with elements
    func fillHoles() -> [[Element]] {
        var columns: [[Element]] = []
        
        for column in 0..<self.columns {
            var arr: [Element] = []
            for row in 0..<self.rows {
                // If a tile has no element
                if tiles[column][row] != nil && elements[column][row] == nil {
                    // Find the element that is right above the hole
                    for examinedRow in (row + 1)..<self.rows {
                        if let element = elements[column][examinedRow] {
                            // Move the element to the hole
                            elements[column][examinedRow] = nil
                            elements[column][row] = element
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
        
        for col in 0..<self.columns {
            var arr: [Element] = []
            var r = self.rows - 1
            while r >= 0 && elements[col][r] == nil {
                var newType: ElementType
                // The newly create element cannot have the same type with the last new element
                repeat {
                    newType = ElementType.random()
                } while newType == lastType
                lastType = newType
                
                // Create new element
                if tiles[col][r] != nil {
                    let newElement = Element(column: col, row: r, type: newType)
                    elements[col][r] = newElement
                    arr.append(newElement)
                    r -= 1
                }
                
            }
            if !arr.isEmpty {
                columns.append(arr)
            }
        }
        return columns
    }
    
    // MARK: Target management
    func updateQuantity(for chains: Set<Chain>) -> [String: Int] {
        // Dictionary to store the target with the reduced quantity, setting initial value to 0
        var reduction: [String: Int] = goals.reduce(into: [String: Int]()) { dict, goal in
            dict[goal.target] = 0
        }
        for chain in chains {
            // Check if an element in the chain has the same type with the target
            for i in 0..<goals.count {
                if chain.elements[0].type == ElementType.getType(name: goals[i].target) {
                    // If the key exists, add the reduced quantity
                    if reduction.keys.contains(goals[i].target) {
                        reduction[goals[i].target]! += chain.length
                    }
                    else {
                        reduction[goals[i].target]! = chain.length
                    }
                    
                }
            }
        }
        return reduction
    }
    
    // MARK: Score calculation
    // Calculate score gained from the chain
    private func calcScore(for chains: Set<Chain>) {
        for chain in chains {
            // 3-element chain is 60 pts.
            // Each more chain is worth another 60 pts
            // In combo scenario, the second chain is worth twice the score and so on
            chain.score = 60 * (chain.length - 2) * combo
            combo += 1
        }
    }
    
    func resetCombo() {
        self.combo = 1
    }
    
    func getCombo() -> Int {
        return self.combo
    }
    
}

