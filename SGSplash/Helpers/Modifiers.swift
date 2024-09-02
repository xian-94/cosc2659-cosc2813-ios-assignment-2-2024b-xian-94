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
            .font(.system(size: UIScreen.main.bounds.width * 0.04))
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
            .font(.system(size: UIScreen.main.bounds.width * 0.04))
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
            .font(.system(size: UIScreen.main.bounds.width * 0.04))
            .background(Color.appPrimary)
            .clipShape(Capsule())
            .shadow(color: .secondBg, radius: 1, y: 10)
            .transition(.opacity)
            .controlSize(.large)
    }
}

struct TutorialText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: UIScreen.main.bounds.width * 0.03))
            .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
            .foregroundStyle(Color.appText)
            .padding()
            .background(Color.background.opacity(0.8))
            .cornerRadius(10)
            .transition(.scale)
            .zIndex(2)
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.05)
            .multilineTextAlignment(.center)
    }
}

struct TutorialArrow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: UIScreen.main.bounds.width * 0.05))
            .fontWeight(.heavy)
            .foregroundStyle(Color.appPrimary)
            .zIndex(10)
    }
}

struct TitleTextSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Raleway", size: UIScreen.main.bounds.width * 0.05))
    }
}

struct MediumTextSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Raleway", size: UIScreen.main.bounds.width * 0.04))
    }
}

struct NormalTextSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Raleway", size: UIScreen.main.bounds.width * 0.03))
    }
}

