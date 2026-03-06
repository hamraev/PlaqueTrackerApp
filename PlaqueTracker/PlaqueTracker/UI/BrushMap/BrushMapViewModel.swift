import Foundation
import Combine

@MainActor
final class BrushMapViewModel: ObservableObject {
    enum Zone: CaseIterable, Hashable {
        case upperLeft, upperRight, lowerLeft, lowerRight

        var title: String {
            switch self {
            case .upperLeft: return "Upper Left"
            case .upperRight: return "Upper Right"
            case .lowerLeft: return "Lower Left"
            case .lowerRight: return "Lower Right"
            }
        }
    }

    @Published private(set) var zoneIntensity: [Zone: Double] = [
        .upperLeft: 0.2, .upperRight: 0.2, .lowerLeft: 0.2, .lowerRight: 0.2
    ]

    private var cancellables = Set<AnyCancellable>()

    /// Call this with plaqueScore 0-100. Internally smooths + updates at ~1Hz.
    func bind(plaqueScorePublisher: AnyPublisher<Double, Never>) {
        // Rolling smoothing + rate limiting (stops the "too fast" feeling)
        plaqueScorePublisher
            .map { min(max($0, 0), 100) }
            .throttle(for: .seconds(1.0), scheduler: RunLoop.main, latest: true)
            .scan((prev: 50.0, current: 50.0)) { state, newValue in
                // Exponential smoothing: display = 85% old + 15% new
                let smoothed = state.current * 0.85 + newValue * 0.15
                return (prev: state.current, current: smoothed)
            }
            .map { $0.current }
            .sink { [weak self] smoothedScore in
                self?.updateZones(from: smoothedScore)
            }
            .store(in: &cancellables)
    }

    private func updateZones(from plaqueScore: Double) {
        // Heuristic: higher plaqueScore => more “needs brushing” everywhere,
        // but we also vary quadrants a bit so kids get guidance.
        // Later replace with real per-zone data from Arduino.
        let base = plaqueScore / 100.0 // 0...1

        // Slight deterministic variation based on score (stable, not random flicker)
        let wiggle = (sin(plaqueScore / 12.0) + 1.0) * 0.08 // 0..0.16

        zoneIntensity[.upperLeft]  = clamp(base + wiggle * 0.6)
        zoneIntensity[.upperRight] = clamp(base + wiggle * 0.3)
        zoneIntensity[.lowerLeft]  = clamp(base + wiggle * 0.2)
        zoneIntensity[.lowerRight] = clamp(base + wiggle * 0.7)
    }

    private func clamp(_ v: Double) -> Double { min(max(v, 0.05), 1.0) }
}
