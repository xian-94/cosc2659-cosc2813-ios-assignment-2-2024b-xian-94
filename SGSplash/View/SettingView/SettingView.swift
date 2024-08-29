//
//  SettingView.swift
//  SGSplash
//
//  Created by Xian on 26/8/24.
//

import Foundation
import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) private var scheme: ColorScheme
    @AppStorage("user_theme") private var theme: Theme = .light
    @State private var isMusicPlaying: Bool = true
    var body: some View {
        VStack(alignment: .leading) {
            ToggleThemeView(scheme: scheme)
            MuteBackgroundMusic(isPlaying: $isMusicPlaying)
            LanguagePicker()
            ModePicker()
        }
        .padding()
        .preferredColorScheme(theme.colorScheme)
    }
}

struct SettingView_Preview: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(LanguageManager())
    }
}
