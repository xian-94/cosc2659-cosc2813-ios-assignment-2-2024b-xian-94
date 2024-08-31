//
//  PlayerRow.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation
import SwiftUI

// TODO: Add data and modify font later
struct PlayerRow: View {
    var rank: Int
    var player: Player
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(30)
                .frame(width: .infinity)
                .frame(minHeight: UIScreen.main.bounds.height * 0.05, maxHeight: UIScreen.main.bounds.height * 0.1)
                .foregroundStyle(Color.background)
                .opacity(0.3)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.appAccent, lineWidth: 4)
                }
            HStack(spacing: UIScreen.main.bounds.width * 0.08) {
                Text("\(rank)")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.appText)
                    .shadow(radius: 5, y: 5)
                Text(player.username)
                    .foregroundColor(.appText)
                        .font(.subheadline)
                Text("\(player.totalScore)")
                    .foregroundColor(.appText)
                Image(player.achievementBadge[player.achievementBadge.count - 1])
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width * 0.08, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.06, maxHeight: UIScreen.main.bounds.height * 0.08)
                
                
                
            }
                
        }
        .padding()
    }
}

struct PlayerRow_Preview: PreviewProvider {
    static var previews: some View {
        PlayerRow(rank: 4, player: leaderboard[0])
    }
}
