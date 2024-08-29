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
    @State private var selectedBar: String?
    var body: some View {
        VStack {
            Text("Top 5 players scores")
                .font(.headline)
                .foregroundStyle(Color.appText)
            Chart(topPlayers.prefix(5)) { player in
                BarMark(
                    x: .value("Player", player.username),
                    y: .value("Score", player.totalScore)
                )
                .cornerRadius(10)
                .foregroundStyle(by: .value("Player", player.username))
                
                if selectedBar == player.username {
                    RuleMark(x: .value("Player", player.username))
                        .foregroundStyle(.gray.opacity(0.35))
                        .zIndex(-10)
                        .offset(yStart: 80)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(x: .disabled, y: .disabled)) {
                                VStack(alignment: .leading) {
                                    Text(player.username)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .foregroundStyle(.appText)
                                    HStack {
                                        Text("Score")
                                        Text("\(player.totalScore)")
                                    }
                                }
                                .frame(minWidth: UIScreen.main.bounds.width * 0.2, maxWidth: UIScreen.main.bounds.width * 0.3, minHeight: UIScreen.main.bounds.height * 0.05, maxHeight: UIScreen.main.bounds.height * 0.1)
                                .padding()
                                .background(Color.secondBg, in: .rect(cornerRadius: 5))
                            }
                }
            }
            .chartXSelection(value: $selectedBar)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .automatic)
            }
            
            .chartLegend(.hidden)
            .padding()
            .background(Color(.background))
            .cornerRadius(10)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.4)
        }
      
    }
    
}

