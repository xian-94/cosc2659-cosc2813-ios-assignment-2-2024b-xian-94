//
//  Tabs.swift
//  SGSplash
//
//  Created by Xian on 29/8/24.
//

import Foundation
import SwiftUI

struct Tabs: View {
    @Binding var players: [Player]
    // Hold the selected tab index
    @State private var selected = 0
    let titles = ["Top Ten", "Statistics"]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                // Loop through each title for display
                ForEach(0..<titles.count, id: \.self) { i in
                    Text(titles[i])
                        .modifier(NormalTextSizeModifier())
                    // Selected title has a different color
                        .foregroundColor(self.selected == i ? Color.appText : Color.appPrimary)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.02)
                    // Selected title has an oustanding background
                        .background(Color.secondary.opacity(self.selected == i ? 1 : 0))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.default) {
                                self.selected = i
                            }
                        }
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }
            }
            .background(Color.appSecondary.opacity(0.4))
            .cornerRadius(10)
            .padding(.horizontal)
            .frame(minWidth: UIScreen.main.bounds.width * 0.4, maxWidth: UIScreen.main.bounds.width * 0.5)
            
            // Display tabs based on index chosen
            if self.selected == 0 {
                TopPlayerView(topPlayers: $players)
            }
            else if self.selected == 1 {
                VStack {
                    PlayerScoresBarChart(topPlayers: $players)
                    PlayerScoreLineChart(players: $players)
                }
            }
        }
    }
}
