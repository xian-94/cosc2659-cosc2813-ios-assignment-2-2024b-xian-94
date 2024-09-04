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
            VStack(spacing: 0.5) {
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

