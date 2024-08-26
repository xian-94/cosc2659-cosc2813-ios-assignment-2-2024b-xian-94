//
//  SettingView.swift
//  SGSplash
//
//  Created by Xian on 26/8/24.
//

import Foundation
import SwiftUI

struct SettingView: View {
    @State private var isMusicPlaying: Bool = true
    var body: some View {
        VStack {
            MuteBackgroundMusic(isPlaying: $isMusicPlaying)
            LanguagePicker()
        }
    }
}

struct SettingView_Preview: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
