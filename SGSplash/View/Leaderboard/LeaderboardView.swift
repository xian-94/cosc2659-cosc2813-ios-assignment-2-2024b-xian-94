//
//  LeaderboardView.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation
import SwiftUI

struct LeaderboardView: View {
    @State private var topPlayers: [Player] = UserDefaults.standard.players(forKey: "leaderboard") ?? leaderboard
//    @State private var currentPlayer: Player?
//    @State private var currentPlayerRank: Int?
    
    var body: some View {
        TopPlayerView(topPlayers: $topPlayers)
    }
}

struct LeaderboardView_Preview: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
