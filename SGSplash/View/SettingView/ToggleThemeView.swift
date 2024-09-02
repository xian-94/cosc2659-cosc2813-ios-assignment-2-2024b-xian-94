//
//  ToggleThemeButton.swift
//  SGSplash
//
//  Created by Xian on 27/8/24.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    
    // Adjust color scheme
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

struct ToggleThemeView: View {
    var scheme: ColorScheme
    @AppStorage("user_theme") private var theme: Theme = .light
    @Namespace var animation
    var body: some View {
        HStack(spacing: UIScreen.main.bounds.width * 0.1) {
            Text("Theme")
                .modifier(NormalTextSizeModifier())
            HStack {
                // Display the theme for user to choose
                ForEach(Theme.allCases, id: \.rawValue) {
                    th in
                    Text(th.rawValue)
                        .modifier(NormalTextSizeModifier())
                        .padding(.vertical, 10)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .background {
                            ZStack {
                                // Highlight the chosen theme 
                                if theme == th {
                                    Capsule()
                                        .fill(Color.secondBg)
                                        .matchedGeometryEffect(id: "ACTIVE", in: animation)
                                }
                            }
                            .animation(.snappy, value: theme)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            theme = th
                        }
                }
            }
            .padding()
            .environment(\.colorScheme, scheme)
        }
    }
}
