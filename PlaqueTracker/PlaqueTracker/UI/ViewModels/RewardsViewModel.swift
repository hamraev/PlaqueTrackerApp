//
//  RewardsViewModel.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import Foundation
import Combine

/// Manages achievements and rewards state
@MainActor
class RewardsViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var totalXP: Int = 0
    @Published var unlockedCount: Int = 0
    @Published var selectedCategory: AchievementCategory = .getting_started
    @Published var latestUnlock: Achievement?

    private let storageKey = "PlaqueTracker.achievements.v1"
    
    init() {
        initializeAchievements()
    }

    func reload() {
        initializeAchievements()
    }
    
    /// Initialize with template achievements
    private func initializeAchievements() {
        self.achievements = loadPersistedAchievements()
        updateStats()
    }
    
    /// Update calculated statistics
    func updateStats() {
        unlockedCount = achievements.filter { $0.isUnlocked }.count
        totalXP = achievements
            .filter { $0.isUnlocked }
            .reduce(0) { $0 + xpReward(for: $1) }
    }
    
    /// Get achievements for current category
    var filteredAchievements: [Achievement] {
        achievements.filter { $0.category == selectedCategory }
    }
    
    /// Get achievements grouped by category
    var achievementsByCategory: [AchievementCategory: [Achievement]] {
        Dictionary(grouping: achievements, by: { $0.category })
    }
    
    /// Get all unlocked achievements
    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }
    
    /// Get achievements sorted by unlock date (newest first)
    var recentUnlocks: [Achievement] {
        unlockedAchievements
            .sorted { ($0.unlockedDate ?? Date.distantPast) > ($1.unlockedDate ?? Date.distantPast) }
            .prefix(3)
            .map { $0 }
    }
    
    /// Get progress achievements (locked but with progress)
    var progressAchievements: [Achievement] {
        achievements
            .filter { !$0.isUnlocked && $0.progress > 0 }
            .sorted { $0.progressPercentage > $1.progressPercentage }
    }
    
    /// Unlock an achievement
    func unlock(achievement: Achievement) {
        if let index = achievements.firstIndex(where: { $0.id == achievement.id }) {
            guard !achievements[index].isUnlocked else { return }
            achievements[index].isUnlocked = true
            achievements[index].progress = max(achievements[index].progress, achievements[index].requirement.targetValue)
            achievements[index].unlockedDate = Date()
            updateStats()
            save()
            latestUnlock = achievements[index]
            AppFeedbackManager.shared.badgeUnlocked()
        }
    }
    
    /// Update achievement progress
    func updateProgress(for achievementID: String, progress: Int) {
        if let index = achievements.firstIndex(where: { $0.id == achievementID }) {
            achievements[index].progress = max(progress, 0)
            
            // Check if achievement should be unlocked
            if progress >= achievements[index].requirement.targetValue && !achievements[index].isUnlocked {
                unlock(achievement: achievements[index])
            } else {
                save()
            }
        }
    }

    /// Evaluate every achievement against current app totals.
    func apply(snapshot: AchievementProgressSnapshot) {
        let requirements = achievements.map { ($0.id, $0.requirement) }
        for (achievementID, requirement) in requirements {
            updateProgress(for: achievementID, progress: progress(for: requirement, in: snapshot))
        }
    }
    
    /// Get category statistics
    func categoryStats(for category: AchievementCategory) -> (total: Int, unlocked: Int) {
        let categoryAchievements = achievements.filter { $0.category == category }
        let unlockedCount = categoryAchievements.filter { $0.isUnlocked }.count
        return (categoryAchievements.count, unlockedCount)
    }

    func dismissLatestUnlock() {
        latestUnlock = nil
    }

    private func progress(for requirement: AchievementRequirement, in snapshot: AchievementProgressSnapshot) -> Int {
        switch requirement {
        case .scanCount:
            return snapshot.scanCount
        case .streakDays:
            return snapshot.streakDays
        case .xpPoints:
            return snapshot.xpPoints
        case .brushingTime:
            return snapshot.brushingMinutes
        case .consistentDays:
            return snapshot.consistentPerfectDays
        case .perfectionCount:
            return snapshot.perfectScanCount
        }
    }

    private func loadPersistedAchievements() -> [Achievement] {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let persisted = try? JSONDecoder().decode([Achievement].self, from: data)
        else {
            return Achievement.templates
        }

        let persistedByID = Dictionary(uniqueKeysWithValues: persisted.map { ($0.id, $0) })

        return Achievement.templates.map { template in
            guard let saved = persistedByID[template.id] else { return template }

            var merged = template
            merged.isUnlocked = saved.isUnlocked
            merged.unlockedDate = saved.unlockedDate
            merged.progress = saved.progress
            return merged
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(achievements) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
        updateStats()
    }

    private func xpReward(for achievement: Achievement) -> Int {
        switch achievement.requirement.targetValue {
        case 0...1:
            return 25
        case 2...10:
            return 50
        case 11...50:
            return 100
        default:
            return 150
        }
    }
}
