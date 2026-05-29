//
//  AppFeedbackManager.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import AudioToolbox
import Foundation

#if canImport(UIKit)
import UIKit
#endif

final class AppFeedbackManager {
    static let shared = AppFeedbackManager()

    private let settings = AppSettings.shared

    private init() {}

    func scanCompleted() {
        play(sound: 1057)
        notify(.success)
    }

    func badgeUnlocked() {
        play(sound: 1025)
        notify(.success)
    }

    func streakContinued() {
        play(sound: 1104)
        impact(.light)
    }

    func brushingMissionCompleted() {
        play(sound: 1057)
        notify(.success)
    }

    private func play(sound: SystemSoundID) {
        guard settings.soundEnabled else { return }
        AudioServicesPlaySystemSound(sound)
    }

    private func notify(_ type: FeedbackType) {
        guard settings.hapticsEnabled else { return }
        #if canImport(UIKit)
        switch type {
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        #endif
    }

    private func impact(_ style: ImpactStyle) {
        guard settings.hapticsEnabled else { return }
        #if canImport(UIKit)
        switch style {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        #endif
    }
}

private enum FeedbackType {
    case success
}

private enum ImpactStyle {
    case light
}
