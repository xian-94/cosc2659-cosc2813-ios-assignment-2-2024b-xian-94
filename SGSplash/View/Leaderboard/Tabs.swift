//
//  Tabs.swift
//  SGSplash
//
//  Created by Xian on 29/8/24.
//

import Foundation
import SwiftUI

struct Tabs: View {
    @Binding var players: [Player]
       // Hold the selected tab index
       @State private var selected = 0
       let titles = ["Top Ten", "Statistics"]
       
       var body: some View {
           VStack(spacing: 20) {
               HStack(spacing: 0) {
                   // Loop through each title for display
                   ForEach(0..<titles.count, id: \.self) { i in
                       Text(titles[i])
                           .font(.title2)
                       // Selected title has a different color
                           .foregroundColor(self.selected == i ? Color.appText : Color.appPrimary)
                           .fontWeight(.bold)
                           .padding(.vertical, 10)
                           .padding(.horizontal, 20)
                       // Selected title has an oustanding background
                           .background(Color.secondary.opacity(self.selected == i ? 1 : 0))
                           .cornerRadius(10)
                           .onTapGesture {
                               withAnimation(.default) {
                                   self.selected = i
                               }
                           }
                       Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                   }
               }
               .background(Color.appSecondary.opacity(0.4))
               .cornerRadius(10)
               .padding(.horizontal)
               .frame(width: UIScreen.main.bounds.width * 0.75)
               
               // Display tabs based on index chosen
               if self.selected == 0 {
                   ScrollView {
                       TopPlayerView(topPlayers: $players)
                   }
               }
               else if self.selected == 1 {
                   ScrollView {
                       VStack {
                           PlayerScoresBarChart(topPlayers: $players)
                           PlayerScoreLineChart(players: $players)
                       }
               }
               }
           }
       }
}
