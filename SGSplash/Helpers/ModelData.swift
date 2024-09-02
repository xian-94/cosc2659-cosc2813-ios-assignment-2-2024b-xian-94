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

// Import levels data
var easyLevels = loadLevels(fileName: "easy")
var medLevels = loadLevels(fileName: "medium")
var hardLevels = loadLevels(fileName: "hard")
var tutorial = loadLevels(fileName: "tutorial")
var easyAnimalLevels = loadLevels(fileName: "easy-animals")
var mediumAnimalLevels = loadLevels(fileName: "medium-animals")
var hardAnimalLevels = loadLevels(fileName: "hard-animals")

