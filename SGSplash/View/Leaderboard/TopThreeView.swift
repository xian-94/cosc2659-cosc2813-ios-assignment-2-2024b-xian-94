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
                .modifier(MediumTextSizeModifier())
                .offset(y: -10)
        }
    }
}

struct TopThreeView_Preview: PreviewProvider {
    static var previews: some View {
        TopThreeView(player: leaderboard[0], rank: "secondRank")
    }
}
