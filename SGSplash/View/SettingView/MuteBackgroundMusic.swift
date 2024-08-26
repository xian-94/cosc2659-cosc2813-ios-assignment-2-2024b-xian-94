//
//  MuteBackgroundMusic.swift
//  SGSplash
//
//  Created by Xian on 26/8/24.
//

import Foundation
import SwiftUI

struct MuteBackgroundMusic: View {
    @Binding var isPlaying: Bool
    var body: some View {
        HStack {
            Text("Background Music")
                .font(.headline)
            Button(action: {
                isPlaying.toggle()
                if isPlaying {
                    BackgroundMusicManager.shared.start()
                }
                else {
                    BackgroundMusicManager.shared.stop()
                }
            }) {
                Image(systemName: isPlaying ?  "speaker.wave.2.fill": "speaker.zzz.fill")
                    .foregroundStyle(Color.primaryPink)
            }
        }
    }
}
