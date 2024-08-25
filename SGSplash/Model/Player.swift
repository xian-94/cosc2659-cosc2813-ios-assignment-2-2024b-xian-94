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
    Player(username: "laans", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "zoro", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "chopper", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "nami", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "sanji", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "hina", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "ace", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "vivi", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "koroo", totalScore: 1023, achievementBadge: "firstStep"),
    Player(username: "smoker", totalScore: 1023, achievementBadge: "firstStep"),
    
]
