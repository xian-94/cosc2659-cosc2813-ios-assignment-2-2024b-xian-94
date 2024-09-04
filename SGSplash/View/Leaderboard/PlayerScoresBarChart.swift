/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Truong Hong Van
  ID: 3957034
  Created  date: 20/08/2024
  Last modified: 04/09/2024
  Acknowledgement:
 Colligan (2018) How to make a game like Candy Crush with SpriteKit: Part 1, Kodeco website, accessed 20/08/2024. https://www.kodeco.com/55-how-to-make-a-game-like-candy-crush-with-spritekit-and-swift-part-1
 Hacking with Swift website, accessed 20/08/2024. https://www.hackingwithswift.com/
 Pereira (2022) Using SpriteKit in a SwiftUI project, Create with Swift website, accessed 20/08/2024. https://www.createwithswift.com/using-spritekit-in-a-swiftui-project/#:~:text=Even%20though%20the%20default%20Game%20Xcode%20Template%20creates%20the%20project
 
*/

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
                .modifier(MediumTextSizeModifier())
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
                                            .modifier(NormalTextSizeModifier())
                                        Text("\(player.totalScore)")
                                            .modifier(NormalTextSizeModifier())
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

