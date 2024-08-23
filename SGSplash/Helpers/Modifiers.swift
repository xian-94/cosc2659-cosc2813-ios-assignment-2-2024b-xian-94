//
//  Modifiers.swift
//  SGSplash
//
//  Created by Xian on 21/8/24.
//

import Foundation
import SwiftUI

struct CircleButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.second)
            .font(.title)
            .frame(minWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.1)
            .background(Color.background)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .shadow(radius: 5)
    }
}

