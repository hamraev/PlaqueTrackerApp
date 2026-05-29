//
//  ScanPhotoSession.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import Foundation

struct ScanPhotoSession: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var beforePhotoPath: String?
    var afterPhotoPath: String?
    var plaqueZonesBefore: Int?
    var plaqueZonesAfter: Int?
    var improvementScore: Int?

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        beforePhotoPath: String? = nil,
        afterPhotoPath: String? = nil,
        plaqueZonesBefore: Int? = nil,
        plaqueZonesAfter: Int? = nil,
        improvementScore: Int? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.beforePhotoPath = beforePhotoPath
        self.afterPhotoPath = afterPhotoPath
        self.plaqueZonesBefore = plaqueZonesBefore
        self.plaqueZonesAfter = plaqueZonesAfter
        self.improvementScore = improvementScore
    }

    var hasBeforePhoto: Bool {
        beforePhotoPath != nil
    }

    var hasAfterPhoto: Bool {
        afterPhotoPath != nil
    }

    var isComplete: Bool {
        hasBeforePhoto && hasAfterPhoto
    }

    var statusText: String {
        guard isComplete else {
            return "Ready for after photo"
        }

        if let before = plaqueZonesBefore, let after = plaqueZonesAfter {
            let cleaned = max(before - after, 0)
            return cleaned > 0 ? "\(cleaned) red zones cleaned" : "Great brushing session!"
        }

        return "Great brushing session!"
    }
}
