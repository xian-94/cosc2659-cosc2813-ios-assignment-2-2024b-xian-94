//
//  LevelComplete.swift
//  SGSplash
//
//  Created by Xian on 23/8/24.
//

import Foundation
import SwiftUI

struct LevelComplete: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.15, maxHeight: UIScreen.main.bounds.height * 0.2)
                .foregroundColor(Color.lightPink)
            VStack {
                Text("Level Complete!")
                    .italic()
                    .font(.largeTitle)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                })  {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                }
            }
        }
    }
}

struct LevelComplete_Preview: PreviewProvider {
    static var previews: some View {
        LevelComplete()
    }
}
