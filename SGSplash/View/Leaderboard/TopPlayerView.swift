//
//  TopPlayerView.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation
import SwiftUI

struct TopPlayerView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.background, Color.lightPink, Color.second], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Text("Leaderboard")
                Spacer()
                HStack(spacing: 15) {
                    TopThreeView()
                        .offset(x: -20, y: -30)
                    TopThreeView()
                        .scaleEffect(CGSize(width: 1.3, height: 1.3))
                    TopThreeView()
                        .offset(x: 20, y: -30)
                }
                VStack(spacing: -35) {
                    PlayerRow()
                    PlayerRow()
                    PlayerRow()
                    PlayerRow()
                    PlayerRow()
                }
            }
            .padding()
        }
       
    }
}

struct TopPlayerView_Preview: PreviewProvider {
    static var previews: some View {
        TopPlayerView()
    }
}
