//
//  LanguagePicker.swift
//  SGSplash
//
//  Created by Xian on 26/8/24.
//

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




