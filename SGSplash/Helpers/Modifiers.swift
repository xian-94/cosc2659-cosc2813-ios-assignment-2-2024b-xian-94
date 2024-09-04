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

struct CircleButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.appText)
            .font(.system(size: UIScreen.main.bounds.width * 0.04))
            .frame(minWidth: UIScreen.main.bounds.width * 0.1, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.1, maxHeight: UIScreen.main.bounds.height * 0.1)
            .background(Color.background)
            .foregroundStyle(Color.appText)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .shadow(radius: 5)
    }
}

struct PrimaryCapsulePButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: UIScreen.main.bounds.width * 0.4, maxWidth: UIScreen.main.bounds.width * 0.6)
            .foregroundColor(.black)
            .font(.system(size: UIScreen.main.bounds.width * 0.04))
            .background(Color.appTertiary)
            .clipShape(Capsule())
            .shadow(color: .secondBg, radius: 1, y: 10)
            .transition(.opacity)
            .controlSize(.large)
    }
}

struct SecondaryCapsulePButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: UIScreen.main.bounds.width * 0.4, maxWidth: UIScreen.main.bounds.width * 0.6)
            .foregroundColor(.black)
            .font(.system(size: UIScreen.main.bounds.width * 0.04))
            .background(Color.appPrimary)
            .clipShape(Capsule())
            .shadow(color: .secondBg, radius: 1, y: 10)
            .transition(.opacity)
            .controlSize(.large)
    }
}

struct TutorialText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: UIScreen.main.bounds.width * 0.03))
            .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
            .foregroundStyle(Color.appText)
            .padding()
            .background(Color.background.opacity(0.8))
            .cornerRadius(10)
            .transition(.scale)
            .zIndex(2)
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.05)
            .multilineTextAlignment(.center)
    }
}

struct TutorialArrow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: UIScreen.main.bounds.width * 0.05))
            .fontWeight(.heavy)
            .foregroundStyle(Color.appPrimary)
            .zIndex(10)
    }
}

struct TitleTextSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Raleway", size: UIScreen.main.bounds.width * 0.05))
    }
}

struct MediumTextSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Raleway", size: UIScreen.main.bounds.width * 0.04))
    }
}

struct NormalTextSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Raleway", size: UIScreen.main.bounds.width * 0.03))
    }
}

