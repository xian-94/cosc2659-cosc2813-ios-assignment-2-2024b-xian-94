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
                Image(rank)
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width * 0.2, maxWidth: UIScreen.main.bounds.width * 0.22, minHeight: UIScreen.main.bounds.height * 0.1, maxHeight: UIScreen.main.bounds.height * 0.12)
            Text(player.username)
                .foregroundColor(.appText)
                .font(.headline)
                .offset(y: -10)
        }
    }
}

struct TopThreeView_Preview: PreviewProvider {
    static var previews: some View {
        TopThreeView(player: leaderboard[0], rank: "secondRank")
    }
}
