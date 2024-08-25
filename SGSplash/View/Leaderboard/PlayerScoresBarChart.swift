//
//  PlayerScoresBarChart.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation
import SwiftUI
import Charts

// Bar chart to compare the scores of top players
struct PlayerScoresBarChart: View {
    @Binding var topPlayers: [Player]
    var body: some View {
        GroupBox("Top 5 Players scores") {
            Chart(topPlayers.prefix(5)) { player in
                BarMark(
                    x: .value("Player", player.username),
                    y: .value("Score", player.totalScore)
                )
                .foregroundStyle(by: .value("Player", player.username))
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .automatic)
            }
        }
        .chartLegend(.hidden)
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.4)
      
    }
    
}

