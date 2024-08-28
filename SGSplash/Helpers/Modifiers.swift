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
            .foregroundColor(.appText)
            .font(.title)
            .frame(minWidth: UIScreen.main.bounds.width * 0.1, maxWidth: UIScreen.main.bounds.width * 0.1, minHeight: UIScreen.main.bounds.height * 0.1, maxHeight: UIScreen.main.bounds.height * 0.1)
            .background(Color.background)
            .foregroundStyle(Color.appText)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .shadow(radius: 5)
    }
}

struct PrimaryCapsulePButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: UIScreen.main.bounds.width * 0.4, maxWidth: UIScreen.main.bounds.width * 0.6)
            .foregroundColor(.black)
            .font(.title)
            .background(Color.appTertiary)
            .clipShape(Capsule())
            .shadow(color: .secondBg, radius: 1, y: 10)
            .transition(.opacity)
            .controlSize(.large)
    }
}

struct SecondaryCapsulePButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: UIScreen.main.bounds.width * 0.4, maxWidth: UIScreen.main.bounds.width * 0.6)
            .foregroundColor(.black)
            .font(.title)
            .background(Color.appPrimary)
            .clipShape(Capsule())
            .shadow(color: .secondBg, radius: 1, y: 10)
            .transition(.opacity)
            .controlSize(.large)
    }
}

