//
//  LiveScanViewModel.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 3/5/26.
//

import Foundation
import AVFoundation

#if canImport(UIKit)
import UIKit
#endif

final class LiveScanViewModel: ObservableObject {
    enum MissionStep {
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

    #if canImport(UIKit)
    func makeMockPhotoData(label: String, color: UIColor) -> Data {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 900, height: 650))
        let image = renderer.image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 900, height: 650))

            UIColor.white.withAlphaComponent(0.94).setFill()
            UIBezierPath(roundedRect: CGRect(x: 170, y: 180, width: 560, height: 250), cornerRadius: 120).fill()

            UIColor.systemBlue.setFill()
            UIBezierPath(ovalIn: CGRect(x: 305, y: 265, width: 55, height: 55)).fill()
            UIBezierPath(ovalIn: CGRect(x: 540, y: 265, width: 55, height: 55)).fill()

            let smilePath = UIBezierPath()
            smilePath.move(to: CGPoint(x: 340, y: 360))
            smilePath.addQuadCurve(to: CGPoint(x: 560, y: 360), controlPoint: CGPoint(x: 450, y: 430))
            UIColor.systemPink.setStroke()
            smilePath.lineWidth = 14
            smilePath.lineCapStyle = .round
            smilePath.stroke()

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 56, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            label.draw(at: CGPoint(x: 280, y: 62), withAttributes: attributes)
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
