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
    // Handle navigation
    @State private var showRegistrationModal = false
    @State private var navigateToLevel: Bool = false
    @State private var navigateToHowToPlay: Bool = false
    @State private var navigateToLeaderboard: Bool = false
    
    // Show the resume game button
    @State private var showResume: Bool = false
    @State private var hasSavedGame: Bool = false
    @State private var savedGame: GameState?
    
    // Show sheet of Setting view
    @State private var showSetting: Bool = false
    @AppStorage("user_theme") private var theme: Theme = .light
    
    // Handle registration
    @State private var username: String = ""
    @State private var isExisted: Bool = false
    @State private var showMessage: Bool = false
    
    // Get player list
    @State private var players = UserDefaults.standard.players(forKey: "players") ?? leaderboard
    
    // Save new user to the UserDefault
    private func register() {
        isExisted = false
        showMessage = false
        let newPlayer = Player(username: username, totalScore: 0, scoreByLevel: [:], achievementBadge: [])
        
        // Not add new player if username exists
        for player in players {
            print(player.username)
            if player.username == newPlayer.username {
                print("Username existed \(newPlayer.username)")
                isExisted = true
                break
            }
        }
        // Add new player
        if !isExisted {
            players.append(newPlayer)
            UserDefaults.standard.setPlayers(players, forKey: "players")
            // Save to UserDefaults
            print("Add new player \(newPlayer.username)")
            newPlayer.saveToUserDefaults()
        }
        
    }
    // Check if there is any current gameplay
    func checkSavedGame() {
        savedGame = GameManager.loadSavedGame()
        if savedGame != nil {
            hasSavedGame = true
        }
        else {
            hasSavedGame = false
        }
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
                    
                    // Show username
                    if !username.isEmpty {
                        Text("Hello, \(username)")
                            .foregroundStyle(Color.appText)
                    }
                    
                    // Show resume button
                    if hasSavedGame {
                        Button(action: {
                            showResume = true
                        }
                        ) {
                            Text("Resume")
                                .foregroundStyle(Color.appText)
                                .padding()
                        }
                        .modifier(PrimaryCapsulePButtonStyle())
                        .navigationDestination(isPresented: $showResume) {
                            if let gameState = savedGame {
                                GameView(savedGame: gameState, levelNumber: gameState.level)
                            }
                        }
                    }
                    
                    // Play button
                    Button(action: {
                        UserDefaults.standard.removeObject(forKey: "savedGame")
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
                        navigateToHowToPlay = true
                    }) {
                        Text("How To Play")
                            .foregroundStyle(Color.appText)
                            .padding()
                    }
                    .modifier(SecondaryCapsulePButtonStyle())
                    .navigationDestination(isPresented: $navigateToHowToPlay) {
                        HowToPlay()
                    }
                    
                    // Leaderboard button
                    Button(action: {
                        navigateToLeaderboard = true
                    }) {
                        Text("Leaderboard")
                            .foregroundStyle(Color.appText)
                            .padding()
                    }
                    .modifier(SecondaryCapsulePButtonStyle())
                    .navigationDestination(isPresented: $navigateToLeaderboard) {
                        LeaderboardView()
                    }
                    
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
                                    showMessage = false
                                    if UserDefaults.standard.string(forKey: "currentUser") != username {
                                        register()
                                    }
                                    if !isExisted {
                                        navigateToLevel = true
                                        showRegistrationModal = false
                                    }
                                    else {
                                        showMessage = true
                                    }
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
                            
                            if showMessage {
                                Text("Username existed. Please try another name!")
                                    .font(.caption)
                                    .foregroundStyle(Color.red)
                            }
                            
                        }
                    }
                }
            }
        }
        // Display setting in sheet 
        .sheet(isPresented: $showSetting) {
            SettingView()
                .presentationDetents([.medium, .large])
                .background(Color.background)
        }
        .onAppear {
            checkSavedGame()
        }
    }
}

struct WelcomeView_Preview: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(LanguageManager())
    }
}
