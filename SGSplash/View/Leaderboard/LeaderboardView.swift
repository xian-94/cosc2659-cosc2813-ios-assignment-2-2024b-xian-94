//
//  LeaderboardView.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation
import SwiftUI

struct LeaderboardView: View {
    @State private var players: [Player] = UserDefaults.standard.players(forKey: "players") ?? leaderboard
    @AppStorage("user_theme") private var theme: Theme = .light
    
    var body: some View {
        ZStack {
            Image(theme == .light ? "lightBackground": "darkbg")
                .resizable()
                .ignoresSafeArea()
                .opacity(0.5)
            ScrollView {
                Text("Leaderboard")
                    .modifier(TitleTextSizeModifier())
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.appAccent)
                    .shadow(radius: 5, y: 5)
                Tabs(players: $players)
                
            }
        }
        
    }
}

struct LeaderboardView_Preview: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
