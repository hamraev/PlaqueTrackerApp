import Foundation

final class MockDeviceManager: DeviceManager {

    var onTelemetry: ((TelemetryPayload) -> Void)?
    var onStateChange: ((String) -> Void)?

    private var timer: Timer?

    func startScan() {
        onStateChange?("Connected")
        startStreaming()
    }

    func stopScan() {
        timer?.invalidate()
        timer = nil
        onStateChange?("Stopped")
    }

    private func startStreaming() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in

            let score = Int.random(in: 10...95)
            let ph = Double.random(in: 6.4...7.2)
            let battery = Int.random(in: 60...100)

            let payload = TelemetryPayload(
                timestamp: Date(),
                plaqueScore: score,
                ph: ph,
                battery: battery
            )

            self.onTelemetry?(payload)
        }
    }
}
