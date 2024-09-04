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

struct CharacterSetPicker: View {
    private var sets = ["food", "animal"]
    @State private var chosenSet: String = "food"
    @Namespace var animation
    // Save the difficulty mode to the user defaults
    private func saveSet() {
        UserDefaults.standard.set(chosenSet, forKey: "characters")
    }
    // Main body view
    var body: some View {
        HStack(spacing: UIScreen.main.bounds.width * 0.1) {
            Text("Characters")
                .modifier(NormalTextSizeModifier())
            HStack(spacing: UIScreen.main.bounds.width * 0.1) {
                    // Display the Difficulty modes
                    ForEach(sets, id: \.self) {
                        cSet in
                        Text(cSet)
                            .modifier(NormalTextSizeModifier())
                            .padding(.vertical, 10)
                            .foregroundStyle(Color.appText)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .background {
                                // Distinguish the chosen mode
                                ZStack {
                                    if chosenSet == cSet {
                                        Capsule()
                                            .fill(Color.secondBg)
                                            .matchedGeometryEffect(id: "ACTIVE", in: animation)
                                    }
                                }
                                .animation(.snappy, value: cSet)
                            }
                            .contentShape(.rect)
                        // Change the mode when tapping
                            .onTapGesture {
                                chosenSet = cSet
                                saveSet()
                            }
                    }
            }
        }
        // Render the view based on the difficulty mode
        if chosenSet == "food" {
            VStack(alignment: .center) {
                HStack {
                    Image("milk")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.05, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.03, maxHeight: UIScreen.main.bounds.height * 0.05)
                    Image("bread")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.05, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.03, maxHeight: UIScreen.main.bounds.height * 0.05)
                }
            }
            .padding()
        }
        else if chosenSet == "animal" {
            VStack(alignment: .center) {
                HStack {
                    Image("rabbit")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.05, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.03, maxHeight: UIScreen.main.bounds.height * 0.05)
                    Image("pig")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.05, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.03, maxHeight: UIScreen.main.bounds.height * 0.05)
                }
            }
            .padding()
        }
    }
}
