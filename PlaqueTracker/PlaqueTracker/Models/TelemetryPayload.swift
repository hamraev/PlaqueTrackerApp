import Foundation

struct TelemetryPayload: Equatable {
    var timestamp: Date
    var plaqueScore: Int
    var ph: Double
    var battery: Int
}
