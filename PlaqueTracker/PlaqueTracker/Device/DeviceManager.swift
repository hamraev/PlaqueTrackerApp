import Foundation

protocol DeviceManager: AnyObject {
    var onTelemetry: ((TelemetryPayload) -> Void)? { get set }
    var onStateChange: ((String) -> Void)? { get set }

    func startScan()
    func stopScan()
}
