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

struct PlayerRow: View {
    var rank: Int
    var player: Player
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                .frame(minHeight: UIScreen.main.bounds.height * 0.05, maxHeight: UIScreen.main.bounds.height * 0.1)
                .foregroundStyle(Color.background)
                .opacity(0.3)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.appAccent, lineWidth: 4)
                }
            HStack(spacing: UIScreen.main.bounds.width * 0.08) {
                Text("\(rank)")
                    .modifier(MediumTextSizeModifier())
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.appAccent)
                    .shadow(radius: 5, y: 5)
                Text(player.username)
                    .foregroundColor(.appText)
                    .modifier(NormalTextSizeModifier())
                Text("\(player.totalScore)")
                    .foregroundColor(.appText)
                    .modifier(NormalTextSizeModifier())
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
