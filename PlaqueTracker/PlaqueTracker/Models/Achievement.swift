//
//  Achievement.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import Foundation

/// Represents a single achievement/milestone in the app
struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: String // Hex color
    let category: AchievementCategory
    let requirement: AchievementRequirement
    var isUnlocked: Bool = false
    var unlockedDate: Date?
    var progress: Int = 0 // Current progress toward requirement

    var badgeAssetName: String {
        "Badge_" + id
            .split(separator: "_")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined()
    }
    
    /// Percentage of completion (0-100)
    var progressPercentage: Int {
        let target = max(requirement.targetValue, 1)
        return min(max((progress * 100) / target, 0), 100)
    }
}

/// Categories for organizing achievements
enum AchievementCategory: String, Codable, CaseIterable {
    case getting_started = "Getting Started"
    case streaks = "Streaks"
    case perfection = "Perfection"
    case consistency = "Consistency"
    case learning = "Learning"
    case social = "Social"
    case special = "Special Events"
}

/// Different types of achievement requirements
enum AchievementRequirement: Codable {
    case scanCount(Int)           // Unlock after N scans
    case streakDays(Int)          // N-day streak
    case xpPoints(Int)            // Reach N XP
    case brushingTime(Int)        // Total brushing time in minutes
    case consistentDays(Int)      // N consecutive perfect days
    case perfectionCount(Int)     // N perfect scans
    
    var targetValue: Int {
        switch self {
        case .scanCount(let value),
             .streakDays(let value),
             .xpPoints(let value),
             .brushingTime(let value),
             .consistentDays(let value),
             .perfectionCount(let value):
            return value
        }
    }
    
    var description: String {
        switch self {
        case .scanCount(let n):
            return "Complete \(n) scans"
        case .streakDays(let n):
            return "\(n)-day streak"
        case .xpPoints(let n):
            return "Earn \(n) XP"
        case .brushingTime(let n):
            return "\(n) minutes brushing"
        case .consistentDays(let n):
            return "\(n) perfect days in a row"
        case .perfectionCount(let n):
            return "\(n) perfect scans"
        }
    }
}

/// Current gameplay totals used to evaluate all achievements in one pass.
struct AchievementProgressSnapshot {
    var scanCount: Int = 0
    var streakDays: Int = 0
    var xpPoints: Int = 0
    var brushingMinutes: Int = 0
    var consistentPerfectDays: Int = 0
    var perfectScanCount: Int = 0
}

// MARK: - Sample Achievements

extension Achievement {
    /// Pre-built achievement templates
    static let templates: [Achievement] = [
        // Getting Started
        Achievement(
            id: "first_scan",
            title: "First Scan",
            description: "Complete your first plaque scan",
            icon: "magnifyingglass",
            color: "#FF9500",
            category: .getting_started,
            requirement: .scanCount(1)
        ),
        Achievement(
            id: "profile_complete",
            title: "Family Hero",
            description: "Complete your profile and settings",
            icon: "star.fill",
            color: "#007AFF",
            category: .getting_started,
            requirement: .scanCount(1) // Placeholder
        ),
        
        // Streaks
        Achievement(
            id: "streak_3",
            title: "3 Day Streak",
            description: "Reach a 3-day streak",
            icon: "flame.fill",
            color: "#FF3B30",
            category: .streaks,
            requirement: .streakDays(3)
        ),
        Achievement(
            id: "streak_7",
            title: "7 Day Streak",
            description: "Reach a 7-day streak",
            icon: "rocket.fill",
            color: "#FF9500",
            category: .streaks,
            requirement: .streakDays(7)
        ),
        Achievement(
            id: "streak_30",
            title: "30 Day Streak",
            description: "Reach a 30-day streak",
            icon: "crown.fill",
            color: "#FFD60A",
            category: .streaks,
            requirement: .streakDays(30)
        ),
        Achievement(
            id: "streak_100",
            title: "Smile Champion",
            description: "Reach a 100-day streak",
            icon: "trophy.fill",
            color: "#5AC8FA",
            category: .streaks,
            requirement: .streakDays(100)
        ),
        
        // Perfection
        Achievement(
            id: "perfect_scan",
            title: "Super Brusher",
            description: "Get a perfect 100 score on a scan",
            icon: "toothbrush.fill",
            color: "#34C759",
            category: .perfection,
            requirement: .perfectionCount(1)
        ),
        Achievement(
            id: "five_perfect",
            title: "Cavity Crusher",
            description: "Get 5 perfect scans",
            icon: "shield.fill",
            color: "#00C7BE",
            category: .perfection,
            requirement: .perfectionCount(5)
        ),
        
        // Consistency
        Achievement(
            id: "ten_scans",
            title: "Plaque Hunter",
            description: "Complete 10 scans",
            icon: "person.fill.questionmark",
            color: "#007AFF",
            category: .consistency,
            requirement: .scanCount(10)
        ),
        Achievement(
            id: "fifty_scans",
            title: "Red Spot Ranger",
            description: "Complete 50 scans",
            icon: "scope",
            color: "#5856D6",
            category: .consistency,
            requirement: .scanCount(50)
        ),
        Achievement(
            id: "hundred_scans",
            title: "Century Club",
            description: "Complete 100 scans",
            icon: "dot.radiowaves.left.and.right",
            color: "#FF2D55",
            category: .consistency,
            requirement: .scanCount(100)
        ),
        
        // Learning
        Achievement(
            id: "read_tips",
            title: "Science Explorer",
            description: "Read all learning tips",
            icon: "testtube.2",
            color: "#34C759",
            category: .learning,
            requirement: .scanCount(1) // Placeholder
        ),
        
        // Social
        Achievement(
            id: "friend_invite",
            title: "Social Butterfly",
            description: "Invite a friend to join",
            icon: "person.2.fill",
            color: "#FF6482",
            category: .social,
            requirement: .scanCount(1) // Placeholder
        ),
        
        // Special
        Achievement(
            id: "earth_day",
            title: "Earth Day Champion",
            description: "Scan on Earth Day",
            icon: "globe.americas.fill",
            color: "#34C759",
            category: .special,
            requirement: .scanCount(1)
        ),
    ]
}
