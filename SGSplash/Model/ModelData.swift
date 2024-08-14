//
//  ModelData.swift
//  SGSplash
//
//  Created by Xian on 13/8/24.
//

import Foundation

func loadLevels(fileName: String) -> [LevelData] {
    if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
        if let data = try? Data(contentsOf: file) {
            do {
                let decoder = JSONDecoder()
                let decoded  = try decoder.decode([LevelData].self, from: data)
                return decoded
            }
            catch {
                fatalError("Failed to decode JSON: \(error)")
            }
        }
        else {
            fatalError("Couldn't load data from \(fileName)")
        }
    }
    else {
        fatalError("Couldn't find \(fileName) file in main bundle")
    }
    return []
}

// Import data
var levels = loadLevels(fileName: "levels")
