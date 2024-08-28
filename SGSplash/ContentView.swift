//
//  ContentView.swift
//  SGSplash
//
//  Created by Xian on 11/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WelcomeView()
    }
}

#Preview {
    ContentView()
        .environmentObject(LanguageManager())
}
