//
//  Board.swift
//  SGSplash
//
//  Created by Xian on 12/8/24.
//

import Foundation

struct Array2D<T> {
    let columns: Int
    let rows: Int
    private var array: [T?]
    
    // Constructor
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        self.array = Array<T?>(repeating: nil, count: self.columns * self.rows)
    }
    
    // Accessing board elements
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row * columns + column]
        }
        set {
            array[row * columns + column] = newValue
        }
    }
}
