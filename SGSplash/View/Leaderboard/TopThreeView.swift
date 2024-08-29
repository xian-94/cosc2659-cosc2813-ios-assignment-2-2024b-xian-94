//
//  TopPlayerDisplay.swift
//  SGSplash
//
//  Created by Xian on 24/8/24.
//

import Foundation
import SwiftUI

struct TopThreeView: View {
    var player: Player
    var rank: String
    var body: some View {
        VStack {
            ZStack {
                Image(rank)
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width * 0.18, maxWidth: UIScreen.main.bounds.width * 0.2, minHeight: UIScreen.main.bounds.height * 0.13, maxHeight: UIScreen.main.bounds.height * 0.15)
            }
            Text(player.username)
                .foregroundColor(.appText)
                .font(.headline)
        }
    }
}

struct TopThreeView_Preview: PreviewProvider {
    static var previews: some View {
        TopThreeView(player: leaderboard[0], rank: "secondRank")
    }
}
