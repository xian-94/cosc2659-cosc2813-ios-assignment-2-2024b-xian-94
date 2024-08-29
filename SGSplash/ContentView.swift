//
//  ContentView.swift
//  SGSplash
//
//  Created by Xian on 11/8/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var languageManager = LanguageManager()
    @AppStorage("user_theme") private var theme: Theme = .light
    init() {
        // Start the background music
        BackgroundMusicManager.shared.start()
    }
    var body: some View {
        WelcomeView()
            .environmentObject(languageManager)
        // Set the locale of the app using the selected language
            .environment(\.locale, .init(identifier: languageManager.selectedLanguage))
            .preferredColorScheme(theme.colorScheme)
           
    }
       
}

#Preview {
    ContentView()
        .environmentObject(LanguageManager())
}
