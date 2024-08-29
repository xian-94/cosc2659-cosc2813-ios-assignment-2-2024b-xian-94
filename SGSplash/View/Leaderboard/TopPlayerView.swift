//
//  TopPlayerView.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation
import SwiftUI

struct TopPlayerView: View {
    @Binding var topPlayers: [Player]
    var body: some View {
        VStack {
            HStack(spacing: UIScreen.main.bounds.width * 0.08) {
                TopThreeView(player: topPlayers[1], rank: "secondRank")
                    .offset(x: -20, y: -20)
                TopThreeView(player: topPlayers[0], rank: "firstRank")
                    .scaleEffect(CGSize(width: 1.3, height: 1.3))
                TopThreeView(player: topPlayers[2], rank: "thirdRank")
                    .offset(x: 20, y: -20)
            }
            VStack(spacing: -20) {
                if topPlayers.count > 3 {
                    ForEach(3..<min(topPlayers.count, 10), id: \.self) { i in
                        PlayerRow(rank: i + 1, player: topPlayers[i])
                    }
                }
            }
        }
        .padding()
    }
}

