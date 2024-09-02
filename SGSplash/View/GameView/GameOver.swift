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
                .frame(maxWidth: UIScreen.main.bounds.width * 0.5, minHeight: UIScreen.main.bounds.height * 0.2, maxHeight: UIScreen.main.bounds.height * 0.3)
                .foregroundColor(Color.background)
                .cornerRadius(20)
            VStack(spacing: 20) {
                Text("Game over!")
                    .italic()
                    .modifier(TitleTextSizeModifier())
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.appText)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                })  {
                    Text("Back to Level")
                        .modifier(MediumTextSizeModifier())
                        .foregroundStyle(Color.appPrimary)
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
