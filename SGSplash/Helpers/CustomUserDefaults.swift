//
//  CustomUserDefaults.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation

// Enable UserDefaults to support Player object
extension UserDefaults {
    // Save the player list 
    func setPlayers(_ players: [Player], forKey key: String) {
        if let encoded = try? JSONEncoder().encode(players) {
            set(encoded, forKey: key)
        }
    }
    
    // Get the player list
    func players(forKey key: String) -> [Player]? {
        if let data = data(forKey: key),
           let decoded = try? JSONDecoder().decode([Player].self, from: data) {
            return decoded
        }
        return nil
    }
}

