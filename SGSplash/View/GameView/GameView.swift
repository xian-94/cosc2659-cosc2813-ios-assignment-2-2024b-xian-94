import SwiftUI
import SpriteKit

struct GameView: View {
    
    @StateObject private var gameManager: GameManager
    
    init(levelNumber: Int) {
        let viewSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        _gameManager = StateObject(wrappedValue: GameManager(viewSize: viewSize, levelNumber: levelNumber))
    }
    var body: some View {
        ZStack {
            Image("lightBackground")
                .resizable()
                .ignoresSafeArea(.all)
            VStack(spacing: 5) {
                HStack {
                    ZStack {
                        UnevenRoundedRectangle( topLeadingRadius: 100, bottomLeadingRadius: 0, bottomTrailingRadius: 100, topTrailingRadius: 100, style: .continuous)
                            .frame(minWidth: UIScreen.main.bounds.width * 0.1, maxWidth: UIScreen.main.bounds.width * 0.3, maxHeight: UIScreen.main.bounds.height * 0.1)
                            .foregroundColor(.primaryPink)
                            .shadow(radius: 5, y: 5)
                        Text("Level \(gameManager.level.number)")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.background)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .offset(x: -50, y: -20)
                    
                    HStack {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                            Image(systemName: "gearshape.fill")
                        }
                        .modifier(CircleButtonStyle())
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                            Image(systemName: "pause.fill")
                        }
                        .modifier(CircleButtonStyle())
                    }
                    .offset(x: 50, y: -20)
                }
                TargetBox(gameManager: gameManager)
                SpriteView(scene: gameManager.scene, options: [.allowsTransparency])
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                    .ignoresSafeArea(.all)
                // Prevent user interaction during swapping
                    .disabled(!gameManager.userInteractionEnabled)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct GameView_Preview: PreviewProvider {
    static var previews: some View {
        GameView(levelNumber: 0)
    }
}
