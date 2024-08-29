//
//  ModePicker.swift
//  SGSplash
//
//  Created by Xian on 28/8/24.
//

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
                .font(.headline)
            HStack(spacing: UIScreen.main.bounds.width * 0.1) {
                    // Display the Difficulty modes
                    ForEach(modes, id: \.self) {
                        mode in
                        Text(mode)
                            .padding(.vertical, 10)
                            .foregroundStyle(Color.appText)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .background {
                                // Distinguish the chosen mode
                                ZStack {
                                    if diffMode == mode {
                                        Capsule()
                                            .fill(Color.background)
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
                        .font(.title)
                        .foregroundStyle(Color.appPrimary)
                }
                
                Text("Beat the level by fulfilling two targets within time limit")
                    .foregroundStyle(Color.appText)
            }
            .padding()
        }
    }
}
