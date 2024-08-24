//
//  PlayerRow.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation
import SwiftUI

// TODO: Add data and modify font later
struct PlayerRow: View {
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(30)
                .frame(width: .infinity)
                .frame(minHeight: UIScreen.main.bounds.height * 0.05, maxHeight: UIScreen.main.bounds.height * 0.08)
                .foregroundStyle(Color.background)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.accentGreen, lineWidth: 3)
                }
            HStack(spacing: 30) {
                Text("4")
                HStack {
                    Image("sadness")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.08, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.08, maxHeight: UIScreen.main.bounds.height * 0.1)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    Text("username")
                        .font(.subheadline)
                }
                Text("4560")
                Image("conqueror")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width * 0.05, maxWidth: UIScreen.main.bounds.width * 0.08, minHeight: UIScreen.main.bounds.height * 0.05, maxHeight: UIScreen.main.bounds.height * 0.06)
                
                
                
            }
                
        }
        .padding()
    }
}

struct PlayerRow_Preview: PreviewProvider {
    static var previews: some View {
        PlayerRow()
    }
}
