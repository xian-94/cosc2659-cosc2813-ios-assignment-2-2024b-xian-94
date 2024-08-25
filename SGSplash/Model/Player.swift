//
//  Player.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation

struct Player: Identifiable, Codable {
    var id = UUID()
    var username: String
    var totalScore: Int
    var achievementBadge: String
}


// Dummy data for leaderboard
var leaderboard: [Player] = [
    Player(username: "xianbaobao", totalScore: 1000, achievementBadge: "conqueror"),
    Player(username: "laansdole", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "laansdole", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "laansdole", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "laansdole", totalScore: 1023, achievementBadge: "firstStep"),
    
]
