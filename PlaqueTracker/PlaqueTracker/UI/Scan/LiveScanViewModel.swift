//
//  LiveScanViewModel.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 3/5/26.
//

import Foundation
import AVFoundation
import Combine

#if canImport(UIKit)
import UIKit
#endif

final class LiveScanViewModel: ObservableObject {
    enum MissionStep: Equatable {
        case takeBefore
        case brushRedSpots
        case takeAfter
        case compare

        var title: String {
            switch self {
            case .takeBefore: return "Start Smile Scan"
            case .brushRedSpots: return "Brush Red Spots"
            case .takeAfter: return "Take After Photo"
            case .compare: return "Compare My Smile"
            }
        }

        var message: String {
            switch self {
            case .takeBefore:
                return "Take a quick before photo so PlaqueTracker can guide your mission."
            case .brushRedSpots:
                return "Nice start. Now brush the red spots on your Brush Map."
            case .takeAfter:
                return "All brushed? Take an after photo to see your progress."
            case .compare:
                return "Great job! Compare your smile and collect your reward."
            }
        }
    }

    @Published private(set) var sessions: [ScanPhotoSession] = []
    @Published var currentSession: ScanPhotoSession?
    @Published var missionStep: MissionStep = .takeBefore
    @Published var permissionMessage: String?

    private let store = ScanPhotoStore()

    var totalScans: Int {
        sessions.count
    }

    var completedSessions: Int {
        sessions.filter(\.isComplete).count
    }

    var averageImprovement: Int {
        let scores = sessions.compactMap(\.improvementScore)
        guard !scores.isEmpty else { return 0 }
        return scores.reduce(0, +) / scores.count
    }

    init() {
        reload()
    }

    func reload() {
        sessions = store.loadSessions()
    }

    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        #if os(iOS)
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionMessage = nil
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.permissionMessage = granted ? nil : "Camera is blocked. You can still use a sample smile photo."
                    completion(granted)
                }
            }
        case .denied, .restricted:
            permissionMessage = "Camera is blocked. You can still use a sample smile photo."
            completion(false)
        @unknown default:
            permissionMessage = "Camera is not ready. Try a sample smile photo."
            completion(false)
        }
        #else
        permissionMessage = "Camera capture runs on iPhone. Use a sample smile photo here."
        completion(false)
        #endif
    }

    func saveBeforePhoto(data: Data, plaqueScore: Int) {
        var session = ScanPhotoSession(
            plaqueZonesBefore: estimatedRedZones(from: plaqueScore)
        )

        session.beforePhotoPath = store.savePhotoData(data, sessionID: session.id, label: "before")
        currentSession = session
        upsert(session)
        missionStep = .brushRedSpots
    }

    func saveAfterPhoto(data: Data, plaqueScore: Int) {
        var session = currentSession ?? ScanPhotoSession()
        session.afterPhotoPath = store.savePhotoData(data, sessionID: session.id, label: "after")
        session.plaqueZonesAfter = estimatedRedZones(from: plaqueScore)

        if let before = session.plaqueZonesBefore, let after = session.plaqueZonesAfter {
            let cleaned = max(before - after, 0)
            session.improvementScore = min(cleaned * 25, 100)
        } else {
            session.improvementScore = 75
        }

        currentSession = session
        upsert(session)
        missionStep = .compare
    }

    func loadPhotoData(path: String?) -> Data? {
        store.photoData(for: path)
    }

    func resetMission() {
        currentSession = nil
        missionStep = .takeBefore
        permissionMessage = nil
    }

    func addDemoSession() {
        let examples: [(before: Int, after: Int, title: String)] = [
            (4, 1, "Red Zones"),
            (3, 1, "Molars"),
            (1, 0, "Perfect")
        ]

        for (offset, example) in examples.enumerated() {
            #if canImport(UIKit)
            let beforeData = makeDemoSmilePhotoData(label: "Before", plaqueZones: example.before, focus: example.title)
            let afterData = makeDemoSmilePhotoData(label: "After", plaqueZones: example.after, focus: example.title)
            #else
            let beforeData = makeMockPhotoData(label: "Before")
            let afterData = makeMockPhotoData(label: "After")
            #endif

            var session = ScanPhotoSession(
                createdAt: Calendar.current.date(byAdding: .day, value: -offset, to: Date()) ?? Date(),
                plaqueZonesBefore: example.before,
                plaqueZonesAfter: example.after,
                improvementScore: min(max(example.before - example.after, 0) * 25, 100)
            )
            session.beforePhotoPath = store.savePhotoData(beforeData, sessionID: session.id, label: "before")
            session.afterPhotoPath = store.savePhotoData(afterData, sessionID: session.id, label: "after")
            upsert(session)
        }
    }

    func resetDemoData() {
        store.clearAllPhotos()
        sessions = []
        resetMission()
    }

    #if canImport(UIKit)
    func makeMockPhotoData(label: String, color: UIColor) -> Data {
        makeDemoSmilePhotoData(label: label, plaqueZones: label == "Before" ? 4 : 1, focus: "Demo")
    }

    private func makeDemoSmilePhotoData(label: String, plaqueZones: Int, focus: String) -> Data {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 900, height: 650))
        let image = renderer.image { context in
            UIColor(red: 0.88, green: 0.95, blue: 1.0, alpha: 1.0).setFill()
            context.fill(CGRect(x: 0, y: 0, width: 900, height: 650))

            UIColor.white.withAlphaComponent(0.98).setFill()
            UIBezierPath(roundedRect: CGRect(x: 130, y: 170, width: 640, height: 310), cornerRadius: 150).fill()

            UIColor(red: 0.93, green: 0.98, blue: 1.0, alpha: 1.0).setFill()
            UIBezierPath(roundedRect: CGRect(x: 190, y: 250, width: 520, height: 150), cornerRadius: 42).fill()

            UIColor.white.setFill()
            for row in 0..<2 {
                for column in 0..<8 {
                    let x = 210 + column * 61
                    let y = row == 0 ? 238 : 340
                    UIBezierPath(
                        roundedRect: CGRect(x: x, y: y, width: 48, height: 74),
                        cornerRadius: 14
                    ).fill()
                }
            }

            UIColor.systemRed.withAlphaComponent(0.88).setFill()
            let plaqueSpots = [
                CGRect(x: 218, y: 250, width: 28, height: 18),
                CGRect(x: 640, y: 354, width: 30, height: 20),
                CGRect(x: 332, y: 373, width: 34, height: 18),
                CGRect(x: 575, y: 263, width: 28, height: 18)
            ]
            for spot in plaqueSpots.prefix(max(plaqueZones, 0)) {
                UIBezierPath(ovalIn: spot).fill()
            }

            UIColor.systemBlue.setFill()
            UIBezierPath(ovalIn: CGRect(x: 305, y: 115, width: 42, height: 42)).fill()
            UIBezierPath(ovalIn: CGRect(x: 555, y: 115, width: 42, height: 42)).fill()

            let smilePath = UIBezierPath()
            smilePath.move(to: CGPoint(x: 350, y: 535))
            smilePath.addQuadCurve(to: CGPoint(x: 550, y: 535), controlPoint: CGPoint(x: 450, y: 590))
            UIColor.systemPink.setStroke()
            smilePath.lineWidth = 12
            smilePath.lineCapStyle = .round
            smilePath.stroke()

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 48, weight: .bold),
                .foregroundColor: UIColor.systemBlue
            ]
            label.draw(at: CGPoint(x: 70, y: 54), withAttributes: attributes)

            let focusAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 26, weight: .semibold),
                .foregroundColor: UIColor.darkGray
            ]
            focus.draw(at: CGPoint(x: 72, y: 112), withAttributes: focusAttributes)
        }

        return image.jpegData(compressionQuality: 0.86) ?? Data()
    }
    #else
    func makeMockPhotoData(label: String) -> Data {
        Data(label.utf8)
    }
    #endif

    private func upsert(_ session: ScanPhotoSession) {
        var updated = sessions.filter { $0.id != session.id }
        updated.append(session)
        sessions = updated.sorted { $0.createdAt > $1.createdAt }
        store.saveSessions(sessions)
    }

    private func estimatedRedZones(from plaqueScore: Int) -> Int {
        // Future real plaque detection should replace this estimate with detected red-zone count.
        switch plaqueScore {
        case 0...20: return 1
        case 21...45: return 2
        case 46...70: return 3
        default: return 4
        }
    }
}
