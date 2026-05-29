//
//  PlaqueTrackerApp.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 3/3/26.
//

import SwiftUI

@main
struct PlaqueTrackerApp: App {
    @StateObject private var settings = AppSettings.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .preferredColorScheme(settings.colorMode.colorScheme)
        }
    }
}
