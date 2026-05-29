//
//  ScanPhotoStore.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import Foundation

final class ScanPhotoStore {
    private let indexKey = "PlaqueTracker.scanPhotoSessions"
    private let fileManager = FileManager.default

    func loadSessions() -> [ScanPhotoSession] {
        guard
            let data = UserDefaults.standard.data(forKey: indexKey),
            let sessions = try? JSONDecoder().decode([ScanPhotoSession].self, from: data)
        else {
            return []
        }

        return sessions.sorted { $0.createdAt > $1.createdAt }
    }

    func saveSessions(_ sessions: [ScanPhotoSession]) {
        guard let data = try? JSONEncoder().encode(sessions) else { return }
        UserDefaults.standard.set(data, forKey: indexKey)
    }

    func savePhotoData(_ data: Data, sessionID: UUID, label: String) -> String? {
        let directory = photosDirectory()
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)

        let fileName = "\(sessionID.uuidString)-\(label).jpg"
        let url = directory.appendingPathComponent(fileName)

        do {
            try data.write(to: url, options: [.atomic])
            return fileName
        } catch {
            return nil
        }
    }

    func photoData(for path: String?) -> Data? {
        guard let path else { return nil }
        return try? Data(contentsOf: photosDirectory().appendingPathComponent(path))
    }

    func clearAllPhotos() {
        UserDefaults.standard.removeObject(forKey: indexKey)
        try? fileManager.removeItem(at: photosDirectory())
    }

    private func photosDirectory() -> URL {
        let base = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first ?? fileManager.temporaryDirectory
        return base.appendingPathComponent("ScanPhotos", isDirectory: true)
    }
}
