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

struct LanguagePicker: View {
    // Handle change language
    @EnvironmentObject var languageManager: LanguageManager
    let languages = ["English", "Vietnamese"]
    let langCodes = ["en", "vi"]
    
    // Change the language
    func changeLanguage(to languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        // Relaunch the app
        exit(0)
    }
    
    var body: some View {
        HStack {
            Text("Language")
                .modifier(NormalTextSizeModifier())
            // Pick to choose language
            Picker("Language", selection: $languageManager.selectedLanguage) {
                // Loop through the language list
                ForEach(Array(languages.enumerated()), id: \.element) { index, language in
                    Text(language)
                        .modifier(NormalTextSizeModifier())
                        .tag(langCodes[index])
                        
                }
            }
            .padding()
        }
        // Change the language the the user chooses
        .onChange(of: languageManager.selectedLanguage) { oldVal, newVal in
            languageManager.update(to: newVal)
        }
    }
}




