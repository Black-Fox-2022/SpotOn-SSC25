
import SwiftUI

enum Mode {
    case intro
    case level
    case end
}

struct ContentView: View {

    @State var currentMode: Mode = .end

    var body: some View {
        ZStack {
            if currentMode == .intro{
                IntroView(currentMode: $currentMode)
            }else if currentMode == .level{
                Mission_CallResponder(currentMode: $currentMode)
            }else if currentMode == .end{
                EndView(currentMode: $currentMode)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primary.opacity(0.1))
    }
}
