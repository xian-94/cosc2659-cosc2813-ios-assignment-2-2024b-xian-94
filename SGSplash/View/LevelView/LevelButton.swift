//
//  LevelButton.swift
//  SGSplash
//
//  Created by Xian on 21/8/24.
//

import Foundation
import SwiftUI

struct LevelButton: View {
    var level: Int
    var body: some View {
        NavigationLink(destination: GameView(levelNumber: level)) {
            Text("\(level + 1)")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(.background)
        }
        .foregroundColor(.black)
        .font(.title)
        .frame(minWidth: UIScreen.main.bounds.width * 0.2, maxWidth: UIScreen.main.bounds.width * 0.22, minHeight: UIScreen.main.bounds.height * 0.15, maxHeight: UIScreen.main.bounds.height * 0.2)
        .background(Color.appAccent)
        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        .shadow(color: .appSecondary, radius: 1, y: 10)
        .transition(.slide)
    }
}

struct LevelButton_Preview: PreviewProvider {
    static var previews: some View {
        LevelButton(level: 1)
    }
}
