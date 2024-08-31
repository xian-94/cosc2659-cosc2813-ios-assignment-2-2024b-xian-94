//
//  GameState.swift
//  SGSplash
//
//  Created by Xian on 30/8/24.
//

import Foundation
struct GameState: Codable {
    var level: Int
    var score: Int
    var movesLeft: Int
    var goals: [Goal]
    var timeRemaining: Int
    var elements: [[ElementType?]]
    init(level: Int = 1, score: Int = 0, movesLeft: Int = 0, goals: [Goal] = [], timeRemaining: Int = 0, elements: [[ElementType?]]) {
        self.level = level
        self.score = score
        self.movesLeft = movesLeft
        self.goals = goals
        self.timeRemaining = timeRemaining
        self.elements = elements
    }
}

