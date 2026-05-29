//
//  AppSettings.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import Foundation
import Combine
import SwiftUI

enum AppColorMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: return "Match Device"
        case .light: return "Bright"
        case .dark: return "Cozy Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    enum Keys {
        static let childName = "PlaqueTracker.settings.childName"
        static let reminderEnabled = "PlaqueTracker.settings.reminderEnabled"
        static let reminderHour = "PlaqueTracker.settings.reminderHour"
        static let reminderMinute = "PlaqueTracker.settings.reminderMinute"
        static let soundEnabled = "PlaqueTracker.settings.soundEnabled"
        static let hapticsEnabled = "PlaqueTracker.settings.hapticsEnabled"
        static let colorMode = "PlaqueTracker.settings.colorMode"
    }

    @Published var childName: String {
        didSet { UserDefaults.standard.set(childName, forKey: Keys.childName) }
    }

    @Published var reminderEnabled: Bool {
        didSet { UserDefaults.standard.set(reminderEnabled, forKey: Keys.reminderEnabled) }
    }

    @Published var reminderDate: Date {
        didSet {
            let components = Calendar.current.dateComponents([.hour, .minute], from: reminderDate)
            UserDefaults.standard.set(components.hour ?? 19, forKey: Keys.reminderHour)
            UserDefaults.standard.set(components.minute ?? 0, forKey: Keys.reminderMinute)
        }
    }

    @Published var soundEnabled: Bool {
        didSet { UserDefaults.standard.set(soundEnabled, forKey: Keys.soundEnabled) }
    }

    @Published var hapticsEnabled: Bool {
        didSet { UserDefaults.standard.set(hapticsEnabled, forKey: Keys.hapticsEnabled) }
    }

    @Published var colorMode: AppColorMode {
        didSet { UserDefaults.standard.set(colorMode.rawValue, forKey: Keys.colorMode) }
    }

    private init() {
        childName = UserDefaults.standard.string(forKey: Keys.childName) ?? "Smile Star"
        reminderEnabled = UserDefaults.standard.object(forKey: Keys.reminderEnabled) as? Bool ?? false
        soundEnabled = UserDefaults.standard.object(forKey: Keys.soundEnabled) as? Bool ?? true
        hapticsEnabled = UserDefaults.standard.object(forKey: Keys.hapticsEnabled) as? Bool ?? true

        let hour = UserDefaults.standard.object(forKey: Keys.reminderHour) as? Int ?? 19
        let minute = UserDefaults.standard.object(forKey: Keys.reminderMinute) as? Int ?? 0
        reminderDate = Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? Date()

        let mode = UserDefaults.standard.string(forKey: Keys.colorMode) ?? AppColorMode.system.rawValue
        colorMode = AppColorMode(rawValue: mode) ?? .system
    }
}
