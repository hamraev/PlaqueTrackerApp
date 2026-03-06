import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                LiveScanView()
            }
            .tabItem {
                Label("Scan", systemImage: "dot.radiowaves.left.and.right")
            }

            NavigationStack {
                BrushMapView()
            }
            .tabItem {
                Label("Brush Map", systemImage: "mouth.fill")
            }

            NavigationStack {
                LearnView()
            }
            .tabItem {
                Label("Learn", systemImage: "book.fill")
            }

            NavigationStack {
                RewardsView()
            }
            .tabItem {
                Label("Rewards", systemImage: "star.fill")
            }
        }
    }
}
