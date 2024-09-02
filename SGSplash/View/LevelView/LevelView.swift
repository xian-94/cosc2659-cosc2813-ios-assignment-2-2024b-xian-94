import SwiftUI

struct LevelView: View {
    @Binding var username: String
    @State private var navigateBack: Bool = false
    @AppStorage("user_theme") private var theme: Theme = .light
    // Calculate the position of a level button along the path
    private func position(for level: Int, in size: CGSize) -> CGPoint {
        let width = size.width
        let midX = width / 2
        let spacing = size.height / CGFloat(easyLevels.count) // Evenly space levels vertically
        
        let x = midX + (sin(CGFloat(level) * .pi * 1.5 / CGFloat(easyLevels.count)) * width * 0.3)
        let y = spacing * CGFloat(level)
        
        return CGPoint(x: x, y: y)
    }
    
    // Main body
    var body: some View {
        NavigationStack {
            ZStack {
                Image(theme == .light ? "lightBackground" : "darkbg")
                    .resizable()
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            HStack {
                                Text("Let's begin our adventure, \(username)")
                                    .modifier(NormalTextSizeModifier())
                                    .foregroundStyle(Color.appText)
                            }
                            ZStack {
                                // Create a custom path for the levels
                                Path { path in
                                    let width = geometry.size.width
                                    let height = CGFloat(easyLevels.count) * geometry.size.height
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
                                ForEach(0..<easyLevels.count, id: \.self) { index in
                                    let position = self.position(for: index, in: CGSize(width: geometry.size.width, height: CGFloat(easyLevels.count) * UIScreen.main.bounds.height * 0.15))
                                    LevelButton(level: index)
                                        .position(position)
                                }
                            }
                            .frame(minHeight: CGFloat(easyLevels.count) * UIScreen.main.bounds.height * 0.15, maxHeight: CGFloat(easyLevels.count) * UIScreen.main.bounds.height * 0.17)
                            .offset(y: UIScreen.main.bounds.height * 0.1)
                        }
                    }
                }
            }
        }
        
    }
}

