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

enum Theme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    
    // Adjust color scheme
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

struct ToggleThemeView: View {
    var scheme: ColorScheme
    @AppStorage("user_theme") private var theme: Theme = .light
    @Namespace var animation
    var body: some View {
        HStack(spacing: UIScreen.main.bounds.width * 0.1) {
            Text("Theme")
                .modifier(NormalTextSizeModifier())
            HStack {
                // Display the theme for user to choose
                ForEach(Theme.allCases, id: \.rawValue) {
                    th in
                    Text(th.rawValue)
                        .modifier(NormalTextSizeModifier())
                        .padding(.vertical, 10)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .background {
                            ZStack {
                                // Highlight the chosen theme 
                                if theme == th {
                                    Capsule()
                                        .fill(Color.secondBg)
                                        .matchedGeometryEffect(id: "ACTIVE", in: animation)
                                }
                            }
                            .animation(.snappy, value: theme)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            theme = th
                        }
                }
            }
            .padding()
            .environment(\.colorScheme, scheme)
        }
    }
}
