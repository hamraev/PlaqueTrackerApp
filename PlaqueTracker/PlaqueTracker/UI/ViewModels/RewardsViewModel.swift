//
//  RewardsViewModel.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import Foundation
import Combine

/// Manages achievements and rewards state
class RewardsViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var totalXP: Int = 0
    @Published var unlockedCount: Int = 0
    @Published var selectedCategory: AchievementCategory = .getting_started
    
    init() {
        initializeAchievements()
    }
    
    /// Initialize with template achievements
    private func initializeAchievements() {
        var achievements = Achievement.templates
        
        // Simulate some unlocked achievements for preview
        if let index = achievements.firstIndex(where: { $0.id == "first_scan" }) {
            achievements[index].isUnlocked = true
            achievements[index].unlockedDate = Date().addingTimeInterval(-86400 * 2) // 2 days ago
        }
        
        if let index = achievements.firstIndex(where: { $0.id == "streak_3" }) {
            achievements[index].isUnlocked = true
            achievements[index].unlockedDate = Date().addingTimeInterval(-86400 * 1) // 1 day ago
        }
        
        if let index = achievements.firstIndex(where: { $0.id == "ten_scans" }) {
            achievements[index].isUnlocked = true
            achievements[index].unlockedDate = Date().addingTimeInterval(-3600) // 1 hour ago
        }
        
        // Set progress for some locked achievements
        if let index = achievements.firstIndex(where: { $0.id == "streak_7" }) {
            achievements[index].progress = 3 // 3 of 7 days
        }
        
        if let index = achievements.firstIndex(where: { $0.id == "fifty_scans" }) {
            achievements[index].progress = 10 // 10 of 50 scans
        }
        
        self.achievements = achievements
        updateStats()
    }
    
    /// Update calculated statistics
    func updateStats() {
        unlockedCount = achievements.filter { $0.isUnlocked }.count
        // In real app, would calculate from game state
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
            achievements[index].isUnlocked = true
            achievements[index].unlockedDate = Date()
            updateStats()
            // In real app: trigger notification, play sound, animation
        }
    }
    
    /// Update achievement progress
    func updateProgress(for achievementID: String, progress: Int) {
        if let index = achievements.firstIndex(where: { $0.id == achievementID }) {
            achievements[index].progress = progress
            
            // Check if achievement should be unlocked
            if progress >= achievements[index].requirement.targetValue && !achievements[index].isUnlocked {
                unlock(achievement: achievements[index])
            }
        }
    }
    
    /// Get category statistics
    func categoryStats(for category: AchievementCategory) -> (total: Int, unlocked: Int) {
        let categoryAchievements = achievements.filter { $0.category == category }
        let unlockedCount = categoryAchievements.filter { $0.isUnlocked }.count
        return (categoryAchievements.count, unlockedCount)
    }
}
