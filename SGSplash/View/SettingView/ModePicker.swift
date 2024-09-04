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

struct ModePicker: View {
    private var modes = ["easy", "medium", "hard"]
    //    @AppStorage("diffMode") private var diffMode: String = "easy"
    @State private var diffMode: String = "easy"
    @Namespace var animation
    // Save the difficulty mode to the user defaults
    private func saveMode() {
        UserDefaults.standard.set(diffMode, forKey: "diffMode")
    }
    // Main body view
    var body: some View {
        VStack(alignment: .leading) {
            Text("Diffculty")
                .modifier(NormalTextSizeModifier())
            HStack(spacing: UIScreen.main.bounds.width * 0.1) {
                    // Display the Difficulty modes
                    ForEach(modes, id: \.self) {
                        mode in
                        Text(mode)
                            .modifier(NormalTextSizeModifier())
                            .padding(.vertical, 10)
                            .foregroundStyle(Color.appText)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .background {
                                // Distinguish the chosen mode
                                ZStack {
                                    if diffMode == mode {
                                        Capsule()
                                            .fill(Color.secondBg)
                                            .matchedGeometryEffect(id: "ACTIVE", in: animation)
                                    }
                                }
                                .animation(.snappy, value: mode)
                            }
                            .contentShape(.rect)
                        // Change the mode when tapping
                            .onTapGesture {
                                diffMode = mode
                                saveMode()
                            }
                    }
            }
        }
        // Render the view based on the difficulty mode
        if diffMode == "easy" {
            VStack(alignment: .center) {
                Image("milk")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width * 0.05, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.03, maxHeight: UIScreen.main.bounds.height * 0.05)
                Text("Relax and chill while accoplishing one goal for each level.")
                    .foregroundStyle(Color.appText)
                    .modifier(NormalTextSizeModifier())
                
            }
            .padding()
        }
        else if diffMode == "medium" {
            VStack(alignment: .center) {
                HStack {
                    Image("milk")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.05, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.03, maxHeight: UIScreen.main.bounds.height * 0.05)
                    Image("bread")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.05, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.03, maxHeight: UIScreen.main.bounds.height * 0.05)
                }
                
                Text("Get more serious! Beat the level by fulfilling two targets.")
                    .foregroundStyle(Color.appText)
                    .modifier(NormalTextSizeModifier())
            }
            .padding()
        }
        else if diffMode == "hard" {
            VStack(alignment: .center) {
                HStack {
                    Image("milk")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.05, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.03, maxHeight: UIScreen.main.bounds.height * 0.05)
                    Image("bread")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.05, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.03, maxHeight: UIScreen.main.bounds.height * 0.05)
                    Image(systemName: "clock.fill")
                        .modifier(TitleTextSizeModifier())
                        .foregroundStyle(Color.appPrimary)
                }
                
                Text("Beat the level by fulfilling two targets within time limit")
                    .foregroundStyle(Color.appText)
                    .modifier(NormalTextSizeModifier())
            }
            .padding()
        }
    }
}
