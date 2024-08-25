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
        ZStack {
            Image("lightBackground")
                .resizable()
                .ignoresSafeArea()
                .opacity(0.5)
            ScrollView {
                Text("Leaderboard")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                VStack {
                    TopPlayerView(topPlayers: $topPlayers)
                    PlayerScoresBarChart(topPlayers: $topPlayers)
                }
                
            }
        }
        
    }
}

struct LeaderboardView_Preview: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
