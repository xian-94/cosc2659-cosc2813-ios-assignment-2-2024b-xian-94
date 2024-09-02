//
//  BouncingArrow.swift
//  SGSplash
//
//  Created by Xian on 1/9/24.
//

import Foundation
import SwiftUI

struct BouncingArrow: View {
    var rotationDegree: CGFloat
    var xPos: CGFloat
    var yPos: CGFloat
    var direction: String
    // Control the arrow animation
    @State private var isBouncing = false
    var body: some View {
        if direction == "vertical" {
            Image(systemName: "arrow.up")
                .modifier(TutorialArrow())
                .rotationEffect(.degrees(rotationDegree))
                .offset(y: isBouncing ? 10 : 0)
                .position(x: xPos, y: yPos)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                        isBouncing.toggle()
                    }
                }
        }
        else if direction == "horizontal" {
            Image(systemName: "arrow.right")
                .modifier(TutorialArrow())
                .rotationEffect(.degrees(rotationDegree))
                .offset(x: isBouncing ? 10 : 0)
                .position(x: xPos, y: yPos)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                        isBouncing.toggle()
                    }
                }
        }
    }
}
