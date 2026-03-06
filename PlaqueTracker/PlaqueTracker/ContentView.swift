import SwiftUI

struct ContentView: View {
    @State private var hasEnteredApp = false

    var body: some View {
        Group {
            if hasEnteredApp {
                RootTabView()
            } else {
                WelcomeGateView {
                    hasEnteredApp = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
