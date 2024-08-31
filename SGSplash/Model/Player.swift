//
//  Player.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation

struct Player: Identifiable, Codable, Hashable {
    var id = UUID()
    var username: String
    var totalScore: Int
    var scoreByLevel: [String: Int]
    var achievementBadge: [String]
    
    // Save the current player to UserDefaults
    func saveToUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: "currentUser")
        } catch {
            print("Unable to save player data to UserDefaults: \(error)")
        }
    }
    
    // Load a player from UserDefaults
    static func loadFromUserDefaults() -> Player? {
        if let data = UserDefaults.standard.data(forKey: "currentUser") {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(Player.self, from: data)
            } catch {
                print("Unable to load player data from UserDefaults: \(error)")
            }
        }
        return nil
    }
}



// Dummy data for leaderboard
var leaderboard: [Player] = [
    Player(username: "xianbaobao", totalScore: 1000, scoreByLevel: ["1": 203, "2": 200, "3": 300, "4": 700, "5": 450], achievementBadge: ["conqueror"]),
    Player(username: "laans", totalScore: 1023,  scoreByLevel: ["1": 200, "2": 100, "3": 300, "4": 400, "5": 600], achievementBadge: ["firstStep"]),
    Player(username: "zoro", totalScore: 1023,  scoreByLevel: ["1": 190, "2": 300, "3": 500, "4": 700, "5": 650], achievementBadge: ["firstStep"]),
    Player(username: "chopper", totalScore: 1023,  scoreByLevel: ["1": 210, "2": 250, "3": 350, "4": 760, "5": 420], achievementBadge: ["firstStep"]),
    Player(username: "nami", totalScore: 1023,  scoreByLevel: ["1": 203, "2": 200, "3": 300, "4": 700, "5": 450], achievementBadge: ["firstStep"]),
    Player(username: "sanji", totalScore: 1023,  scoreByLevel: ["1": 203, "2": 200, "3": 300, "4": 700, "5": 450], achievementBadge: ["firstStep"]),
    Player(username: "hina", totalScore: 1023,  scoreByLevel: ["1": 203, "2": 200, "3": 300, "4": 700, "5": 450], achievementBadge: ["firstStep"]),
    Player(username: "ace", totalScore: 1023,  scoreByLevel: ["1": 203, "2": 200, "3": 300, "4": 700, "5": 450], achievementBadge: ["firstStep"]),
    Player(username: "vivi", totalScore: 1023,  scoreByLevel: ["1": 203, "2": 200, "3": 300, "4": 700, "5": 450], achievementBadge: ["firstStep"]),
    Player(username: "koroo", totalScore: 1023,  scoreByLevel: ["1": 203, "2": 200, "3": 300, "4": 700, "5": 450], achievementBadge: ["firstStep"]),
    Player(username: "smoker", totalScore: 1023,  scoreByLevel: ["1": 203, "2": 200, "3": 300, "4": 700, "5": 450], achievementBadge: ["firstStep"]),
    
]
