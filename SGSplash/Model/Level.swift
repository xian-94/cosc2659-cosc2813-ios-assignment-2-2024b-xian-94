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
    var id: Int
    var tiles: [[Int]]
    var goal: Int
    var moves: Int
}

class Level {
    // Create a 2D array that holds the elements
    private var elements = Array2D<Element>(columns: columns, rows: rows)
    private var tiles = Array2D<Tile>
    // Constructor
    init(level: Int, fileName: String) {
       
    }
    
    // Get a element based on position
    func element(atColumn column: Int, row: Int) -> Element? {
        if column >= 0 && column < columns && rows >= 0 && rows < rows {
            return elements[column, row]
        }
        return nil
    }
    
    private func createInitialTiles() -> Set<Element> {
        // Use Set for unordered unique list of elements
        var set: Set<Element> = []
        
        // Loop through the array
        for row in 0..<rows {
            for col in 0..<columns {
                let type = ElementType.random()
                
                // Add new tile to the array
                let newTile = Element(column: col, row: row, type: type)
                elements[col, row] = newTile
                
                set.insert(newTile)
            }
        }
        return set
    }
    
    func shuffle() -> Set<Element> {
        return createInitialTiles()
    }
}
