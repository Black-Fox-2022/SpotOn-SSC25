
import SwiftUI

enum Mode {
    case intro
    case level1
    case level2
}

struct ContentView: View {

    @State var currentMode: Mode = .intro

    var body: some View {
        ZStack {
            if currentMode == .intro{
                IntroView(currentMode: $currentMode)
            }else if currentMode == .level1{
                Mission_CallResponder()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primary.opacity(0.1))
    }
}
