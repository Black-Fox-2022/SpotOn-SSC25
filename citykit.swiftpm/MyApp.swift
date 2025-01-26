import SwiftUI
import TipKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { // This .task would normally go on the app root-view
                            try? Tips.resetDatastore()     // not normal use
                            try? Tips.configure([
                                .displayFrequency(.immediate),
                                .datastoreLocation(.applicationDefault),
                            ])
                }
        }
    }
}
