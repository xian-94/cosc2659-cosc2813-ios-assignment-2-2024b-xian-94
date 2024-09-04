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

struct BouncingArrow: View {
    var rotationDegree: CGFloat
    var xPos: CGFloat
    var yPos: CGFloat
    var direction: String
    // Control the arrow animation
    @State private var isBouncing = false
    var body: some View {
        // Vertical arrow direction
        if direction == "vertical" {
            Image(systemName: "arrow.up")
                .modifier(TutorialArrow())
                .rotationEffect(.degrees(rotationDegree))
                .offset(y: isBouncing ? 10 : 0)
                .position(x: xPos, y: yPos)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                        isBouncing.toggle()
                    }
                }
        }
        // Horizontal arrow direction 
        else if direction == "horizontal" {
            Image(systemName: "arrow.right")
                .modifier(TutorialArrow())
                .rotationEffect(.degrees(rotationDegree))
                .offset(x: isBouncing ? 10 : 0)
                .position(x: xPos, y: yPos)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                        isBouncing.toggle()
                    }
                }
        }
    }
}
