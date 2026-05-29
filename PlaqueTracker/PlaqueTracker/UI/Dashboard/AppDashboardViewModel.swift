import Combine
import Foundation

final class AppDashboardViewModel: ObservableObject {
    @Published var smileScore = 82
    @Published var streakDays = 5
    @Published var bestStreak = 12
    @Published var xpPoints = 120
    @Published var level = 3
    @Published var connectionState = "Ready"
    @Published private(set) var scanCount = 0
    @Published private(set) var brushingMinutes = 0
    @Published private(set) var perfectScanCount = 0

    private let deviceManager: DeviceManager
    private let plaqueScoreSubject = CurrentValueSubject<Double, Never>(82)
    private let scanCountKey = "PlaqueTracker.dashboard.scanCount"
    private let brushingMinutesKey = "PlaqueTracker.dashboard.brushingMinutes"
    private let perfectScanCountKey = "PlaqueTracker.dashboard.perfectScanCount"

    var xpToNextLevel: Int {
        max(level * 350, 350)
    }

    var plaqueScorePublisher: AnyPublisher<Double, Never> {
        plaqueScoreSubject.eraseToAnyPublisher()
    }

    init(deviceManager: DeviceManager = MockDeviceManager()) {
        self.deviceManager = deviceManager
        self.scanCount = UserDefaults.standard.integer(forKey: scanCountKey)
        self.brushingMinutes = UserDefaults.standard.integer(forKey: brushingMinutesKey)
        self.perfectScanCount = UserDefaults.standard.integer(forKey: perfectScanCountKey)
        self.deviceManager.onTelemetry = { [weak self] payload in
            DispatchQueue.main.async {
                self?.handle(payload)
            }
        }
        self.deviceManager.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.connectionState = state
            }
        }
    }

    func startScan() {
        deviceManager.startScan()
    }

    func stopScan() {
        deviceManager.stopScan()
    }

    func completeScan() -> AchievementProgressSnapshot {
        scanCount += 1
        brushingMinutes += 2
        streakDays = max(streakDays, 1)
        bestStreak = max(bestStreak, streakDays)

        if smileScore == 100 {
            perfectScanCount += 1
        }

        UserDefaults.standard.set(scanCount, forKey: scanCountKey)
        UserDefaults.standard.set(brushingMinutes, forKey: brushingMinutesKey)
        UserDefaults.standard.set(perfectScanCount, forKey: perfectScanCountKey)

        AppFeedbackManager.shared.streakContinued()

        return AchievementProgressSnapshot(
            scanCount: scanCount,
            streakDays: streakDays,
            xpPoints: totalEarnedXP,
            brushingMinutes: brushingMinutes,
            consistentPerfectDays: perfectScanCount,
            perfectScanCount: perfectScanCount
        )
    }

    private func handle(_ payload: TelemetryPayload) {
        smileScore = max(0, min(100, 100 - payload.plaqueScore))
        plaqueScoreSubject.send(Double(payload.plaqueScore))

        xpPoints += 5
        if xpPoints >= xpToNextLevel {
            xpPoints = xpPoints - xpToNextLevel
            level += 1
        }
    }

    private var totalEarnedXP: Int {
        ((level - 1) * xpToNextLevel) + xpPoints
    }
}
