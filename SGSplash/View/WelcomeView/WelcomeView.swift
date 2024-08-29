//
//  WelcomeView.swift
//  SGSplash
//
//  Created by Xian on 25/8/24.
//

import Foundation
import SwiftUI

// TODO: Store top player from here later
struct WelcomeView: View {
    @State private var showRegistrationModal = false
    @State private var username: String = ""
    @State private var navigateToLevel: Bool = false
    // Show sheet of Setting view
    @State private var showSetting: Bool = false
    @AppStorage("user_theme") private var theme: Theme = .light
    
    // TODO: Check if the user exists in the list
    
    // Save new user to the UserDefault
    private func register() {
        UserDefaults.standard.set(username, forKey: "currentUser")
        // TODO: Add new player to the player list later
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                Image(theme == .light ? "title": "titleDark")
                    .resizable()
                    .ignoresSafeArea(.all)
                VStack(alignment: .center, spacing: 20)
                {
                    if !username.isEmpty {
                        Text("Hello, \(username)")
                            .foregroundStyle(Color.appText)

                    }
                    // Play button
                    Button(action: {
                        if username.isEmpty {
                            showRegistrationModal = true
                        }
                        else {
                            navigateToLevel = true
                        }
                    }
                    ) {
                        Text("Play")
                            .foregroundStyle(Color.appText)
                            .padding()

                           
                    }
                    .modifier(PrimaryCapsulePButtonStyle())
                    .navigationDestination(isPresented: $navigateToLevel) { LevelView(username: $username)
                    }
                    // How to play button
                    Button(action: {
                        
                    }) {
                        Text("How To Play")
                            .foregroundStyle(Color.appText)
                            .padding()
                    }
                    .modifier(SecondaryCapsulePButtonStyle())
                    Button(action: {
                        
                    }) {
                        Text("Leaderboard")
                            .foregroundStyle(Color.appText)
                            .padding()
                    }
                    .modifier(SecondaryCapsulePButtonStyle())
                    // Setting button
                    Button(action: {
                        showSetting = true
                    }) {
                        Text("Setting")
                            .foregroundStyle(Color.appText)
                            .padding()
                    }
                    .modifier(SecondaryCapsulePButtonStyle())
                    
                }
                .offset(y: 180)
                if showRegistrationModal {
                    // Background color to make the popup box outstanding
                    Color(.secondBg).opacity(0.4)
                        .ignoresSafeArea()
                    // Pop up modal
                    ZStack {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.background)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
                        
                        VStack {
                            Text("Register username")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.appText)
                            TextField("Enter your username", text: $username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .frame(width: UIScreen.main.bounds.width * 0.8)
                            HStack {
                                Button(action: {
                                    if UserDefaults.standard.string(forKey: "currentUser") != username {
                                        register()
                                        
                                    }
                                    navigateToLevel = true
                                    showRegistrationModal = false
                                }) {
                                    Text("Let's play")
                                        .foregroundColor(.appText)
                                }
                                .cornerRadius(20)
                                .controlSize(.large)
                                .buttonBorderShape(.capsule)
                                .buttonStyle(.borderedProminent)
                                .tint(.appPrimary).opacity(0.4)
                                .foregroundStyle(.black)
                                .navigationDestination(isPresented: $navigateToLevel) { LevelView(username: $username)
                                }
                                
                                // Button to close the popup
                                Button(action: {
                                    showRegistrationModal = false
                                })  {
                                    Text("Exit")
                                        .foregroundStyle(.appText)
                                }
                                .cornerRadius(20)
                                .controlSize(.large)
                                .buttonBorderShape(.capsule)
                                .buttonStyle(.borderedProminent)
                                .tint(.appAccent).opacity(0.4)
                            }
                            
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showSetting) {
            SettingView()
        }
    }
}

struct WelcomeView_Preview: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(LanguageManager())
    }
}
