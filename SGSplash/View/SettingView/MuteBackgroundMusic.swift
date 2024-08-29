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
            Text("Music")
                .font(.headline)
            Spacer()
                .frame(minWidth: UIScreen.main.bounds.width * 0.2, maxWidth: UIScreen.main.bounds.width * 0.25)
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
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.appPrimary)
            }
        }
    }
}
