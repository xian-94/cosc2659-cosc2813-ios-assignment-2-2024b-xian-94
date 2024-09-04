/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Truong Hong Van
  ID: 3957034
  Created  date: 20/08/2024
  Last modified: 04/09/2024
  Acknowledgement:
 Colligan (2018) How to make a game like Candy Crush with SpriteKit: Part 1, Kodeco website, accessed 20/08/2024. https://www.kodeco.com/55-how-to-make-a-game-like-candy-crush-with-spritekit-and-swift-part-1
 Hacking with Swift website, accessed 20/08/2024. https://www.hackingwithswift.com/
 Pereira (2022) Using SpriteKit in a SwiftUI project, Create with Swift website, accessed 20/08/2024. https://www.createwithswift.com/using-spritekit-in-a-swiftui-project/#:~:text=Even%20though%20the%20default%20Game%20Xcode%20Template%20creates%20the%20project
 
*/

import Foundation
import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) private var scheme: ColorScheme
    @AppStorage("user_theme") private var theme: Theme = .light
    @State private var isMusicPlaying: Bool = true
    var body: some View {
        ZStack {
            // Background color
            Color.background
                .ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                // Display each part of setting components 
                ToggleThemeView(scheme: scheme)
                MuteBackgroundMusic(isPlaying: $isMusicPlaying)
                LanguagePicker()
                CharacterSetPicker()
                ModePicker()
            }
            .padding()
            .preferredColorScheme(theme.colorScheme)
            
        }
        
    }
}

struct SettingView_Preview: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(LanguageManager())
    }
}
