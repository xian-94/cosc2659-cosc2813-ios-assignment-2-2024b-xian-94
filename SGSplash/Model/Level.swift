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
                    let type = ElementType.random()
                    // Add new tile to the array
                    let newTile = Element(column: col, row: row, type: type)
                    elements[col, row] = newTile
                    set.insert(newTile)
                }
            }
        }
        return set
    }
    
    func shuffle() -> Set<Element> {
        return createInitialTiles()
    }
}
