import SwiftUI
import Charts

struct PlayerScoreLineChart: View {
    @Binding var players: [Player]
    @State private var selectedPlayer: Player?
    @State private var selectedPoint: (level: String, score: Int)?
    
    // Display the score by level information of a player
    private func chosenData(player: String, level: String, score: Int) -> some View {
        VStack(alignment: .center, spacing: 2) {
            Text(player)
                .fontWeight(.bold)
                .foregroundStyle(.appText)
            Text("Level: \(level)")
                .foregroundStyle(.appText)
            Text("Score: \(score)")
                .foregroundStyle(.appText)
        }
        .frame(minWidth: UIScreen.main.bounds.width * 0.2, maxWidth: UIScreen.main.bounds.width * 0.3, minHeight: UIScreen.main.bounds.height * 0.05, maxHeight: UIScreen.main.bounds.height * 0.1)
        .padding()
        .background(Color.secondBg.opacity(0.4), in: .rect(cornerRadius: 5))
    }
    
    // Main body view
    var body: some View {
        VStack(spacing: 1) {
            // Player picker: Choose a player to render the chart accordingly
            Text("Player's score by Level")
                .font(.headline)
                .foregroundStyle(Color.appText)
            // Player picker and chosen data in an HStack
            HStack {
                ZStack {
                    Rectangle()
                        .frame(minWidth: UIScreen.main.bounds.width * 0.2, maxWidth: UIScreen.main.bounds.width * 0.4, maxHeight: UIScreen.main.bounds.height * 0.05)
                        .foregroundColor(Color.secondBg.opacity(0.5))
                        .cornerRadius(10)
                    
                    Picker("Select a Player", selection: $selectedPlayer) {
                        ForEach(players) { player in
                            Text(player.username).tag(player as Player?)
                                .foregroundColor(.appText)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                    .padding()
                }
                
                // Display chosen data if a player and point are selected
                if let selectedPlayer = selectedPlayer, let selectedPoint = selectedPoint {
                    chosenData(player: selectedPlayer.username, level: selectedPoint.level, score: selectedPoint.score)
                } else {
                    Text("Tap a point to view more details")
                        .foregroundColor(.gray)
                        .frame(minWidth: UIScreen.main.bounds.width * 0.2, maxWidth: UIScreen.main.bounds.width * 0.3)
                        .background(Color.secondBg.opacity(0.4))
                        .cornerRadius(5)
                }
            }
            .padding()
            // If a player is chosen
            if let selectedPlayer = selectedPlayer {
                // Main line chart view
                Chart {
                    ForEach(Array(selectedPlayer.scoreByLevel.keys.sorted()), id: \.self) { level in
                        if let score = selectedPlayer.scoreByLevel[level] {
                            LineMark(
                                x: .value("Level", level),
                                y: .value("Score", score)
                            )
                            .interpolationMethod(.monotone)
                            .foregroundStyle(by: .value("Player", selectedPlayer.username))
                            
                            PointMark(
                                x: .value("Level", level),
                                y: .value("Score", score)
                            )
                            .foregroundStyle(by: .value("Player", selectedPlayer.username))
                            .symbol(by: .value("Player", selectedPlayer.username))
                        }
                    }
                }
                // Set the axes value
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5))
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .padding()
                .background(Color(.background))
                .cornerRadius(10)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.4)
                
                // Overlay for the tap gesture to display the information
                .overlay(
                    GeometryReader { geometry in
                        let sortedLevels = selectedPlayer.scoreByLevel.keys.sorted()
                        ZStack {
                            ForEach(sortedLevels, id: \.self) { level in
                                if let score = selectedPlayer.scoreByLevel[level] {
                                    // Calculate the position of the point, so that it is near the point mark
                                    let xIndex = sortedLevels.firstIndex(of: level) ?? 0
                                    let xPosition = geometry.size.width * 0.2 + CGFloat(xIndex) / CGFloat(sortedLevels.count) * geometry.size.width * 0.9
                                    let yPosition = (1 - (CGFloat(score) / CGFloat(selectedPlayer.scoreByLevel.values.max() ?? 1))) * geometry.size.height * 0.9
                                    // Set the circle to be nearly opaque, so that it is still tappble
                                    Circle()
                                        .fill(Color.red.opacity(0.01))
                                        .frame(width: 100, height: 100)
                                        .position(x: xPosition, y: yPosition)
                                        .onTapGesture {
                                            selectedPoint = (level: level, score: score)
                                        }
                                }
                            }
                        }
                    }
                )
                
            }
        }
        .onAppear {
            // Set the default selected player as the first player in the list
            if selectedPlayer == nil {
                selectedPlayer = players.first
            }
        }
    }
}
