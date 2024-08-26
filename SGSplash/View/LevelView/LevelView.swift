import SwiftUI

struct LevelView: View {
    @Binding var username: String
    @State private var navigateBack: Bool = false
    // Calculate the position of a level button along the path
    private func position(for level: Int, in size: CGSize) -> CGPoint {
        let width = size.width
        let midX = width / 2
        let spacing = size.height / CGFloat(levels.count) // Evenly space levels vertically
        
        let x = midX + (sin(CGFloat(level) * .pi * 1.5 / CGFloat(levels.count)) * width * 0.3)
        let y = spacing * CGFloat(level)
        
        return CGPoint(x: x, y: y)
    }
    
    // Main body
    var body: some View {
        NavigationStack {
            ZStack {
                Image("lightBackground")
                    .resizable()
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            HStack {
                                Text("Let's begin our adventure, \(username)")
                            }
                            ZStack {
                                // Create a custom path for the levels
                                Path { path in
                                    let width = geometry.size.width
                                    let height = CGFloat(levels.count) * geometry.size.height
                                    let midX = width / 2
                                    
                                    // Create path
                                    path.move(to: CGPoint(x: midX, y: height * 0.1))
                                    path.addCurve(to: CGPoint(x: midX, y: height * 0.9),
                                                  control1: CGPoint(x: width * 0.2, y: height * 0.3),
                                                  control2: CGPoint(x: width * 0.8, y: height * 0.7))
                                }
                                // Hide the path line
                                .stroke(lineWidth: 0)
                                
                                // Position the level buttons
                                ForEach(0..<levels.count, id: \.self) { index in
                                    let position = self.position(for: index, in: CGSize(width: geometry.size.width, height: CGFloat(levels.count) * UIScreen.main.bounds.height * 0.15))
                                    LevelButton(level: index)
                                        .position(position)
                                }
                            }
                            .frame(minHeight: CGFloat(levels.count) * UIScreen.main.bounds.height * 0.15, maxHeight: CGFloat(levels.count) * UIScreen.main.bounds.height * 0.17)
                            .offset(y: UIScreen.main.bounds.height * 0.1)
                        }
                    }
                }
            }
        }
//        .navigationBarBackButtonHidden(true)
        
    }
}

