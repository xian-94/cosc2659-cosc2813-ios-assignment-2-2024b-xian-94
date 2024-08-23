//
//  GameOver.swift
//  SGSplash
//
//  Created by Xian on 23/8/24.
//

import SwiftUI
struct GameOver: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: .infinity, height: UIScreen.main.bounds.height * 0.15)
                .foregroundColor(Color.greenBg)
            VStack {
                Text("Game over!")
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

struct GameOver_Preview: PreviewProvider {
    static var previews: some View {
        GameOver()
    }
}
