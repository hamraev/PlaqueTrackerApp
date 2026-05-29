//
//  RewardsView.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 3/5/26.
//

import SwiftUI

struct RewardsView: View {
    @StateObject private var viewModel = RewardsViewModel()
    @State private var selectedCategory: AchievementCategory = .getting_started
    @State private var showCategoryPicker = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with stats
                headerSection
                
                // Category selector
                categorySelector
                
                // Achievement grid
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        // Recent unlocks
                        if !viewModel.recentUnlocks.isEmpty {
                            recentUnlocksSection
                        }
                        
                        // Progress achievements
                        if !viewModel.progressAchievements.isEmpty {
                            progressSection
                        }
                        
                        // All achievements for category
                        achievementGridSection
                    }
                    .padding(AppTheme.Spacing.md)
                }
            }
            .navigationTitle("Rewards")
            .background(AppColors.background)
        }
    }
}

private extension RewardsView {
    // MARK: - Header Section
    
    var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.lg) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Achievements")
                        .font(AppTheme.headline2)
                    
                    Text("\(viewModel.unlockedCount) of \(viewModel.achievements.count) unlocked")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(viewModel.unlockedCount)")
                        .font(AppTheme.display2)
                        .foregroundColor(AppColors.accent)
                    
                    Text("Badges")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(AppTheme.Spacing.md)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
            .shadowMedium()
            
            // Progress bar
            ProgressCard(
                title: "Collection Progress",
                current: viewModel.unlockedCount,
                total: viewModel.achievements.count,
                color: AppColors.primary
            )
        }
        .padding(AppTheme.Spacing.md)
    }
    
    // MARK: - Category Selector
    
    var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach(AchievementCategory.allCases, id: \.self) { category in
                    categoryButton(category)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
    }
    
    func categoryButton(_ category: AchievementCategory) -> some View {
        let stats = viewModel.categoryStats(for: category)
        let isSelected = selectedCategory == category
        
        return Button(action: { 
            withAnimation(.easeInOut(duration: AppTheme.Animation.standard)) {
                selectedCategory = category
            }
        }) {
            VStack(spacing: 2) {
                Text(category.rawValue)
                    .font(.caption)
                
                Text("\(stats.unlocked)/\(stats.total)")
                    .font(.captionSmall)
            }
            .frame(minWidth: 70)
            .padding(.vertical, AppTheme.Spacing.sm)
            .padding(.horizontal, AppTheme.Spacing.md)
            .background(isSelected ? AppColors.primary : AppColors.cardBackground)
            .foregroundColor(isSelected ? .white : AppColors.text)
            .clipShape(Capsule())
        }
    }
    
    // MARK: - Recent Unlocks Section
    
    var recentUnlocksSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("🎉 Recently Unlocked")
                .font(AppTheme.headline3)
            
            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(viewModel.recentUnlocks) { achievement in
                    recentUnlockCard(achievement)
                }
            }
        }
    }
    
    func recentUnlockCard(_ achievement: Achievement) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(Color(hex: achievement.color).opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: achievement.color))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(AppTheme.headline3)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                if let unlockedDate = achievement.unlockedDate {
                    Text("Unlocked \(unlockedDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.captionSmall)
                        .foregroundColor(AppColors.textTertiary)
                }
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(AppColors.success)
        }
        .padding(AppTheme.Spacing.md)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: achievement.color).opacity(0.08),
                    Color(hex: achievement.color).opacity(0.03)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
        .transition(.asymmetric(insertion: .scale, removal: .opacity))
    }
    
    // MARK: - Progress Section
    
    var progressSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("📈 Almost There")
                .font(AppTheme.headline3)
            
            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(viewModel.progressAchievements) { achievement in
                    progressAchievementCard(achievement)
                }
            }
        }
    }
    
    func progressAchievementCard(_ achievement: Achievement) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color(hex: achievement.color).opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: achievement.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: achievement.color))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(achievement.title)
                        .font(AppTheme.headline3)
                    
                    Text(achievement.description)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Text("\(achievement.progressPercentage)%")
                    .font(AppTheme.bodyBold)
                    .foregroundColor(Color(hex: achievement.color))
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm)
                        .fill(Color(hex: achievement.color).opacity(0.15))
                    
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm)
                        .fill(Color(hex: achievement.color))
                        .frame(width: geometry.size.width * CGFloat(achievement.progressPercentage) / 100)
                        .transition(.asymmetric(insertion: .scale, removal: .identity))
                }
            }
            .frame(height: 6)
            
            Text("\(achievement.progress) / \(achievement.requirement.targetValue) \(requirement(achievement))")
                .font(.captionSmall)
                .foregroundColor(AppColors.textTertiary)
        }
        .padding(AppTheme.Spacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }
    
    // MARK: - Achievement Grid Section
    
    var achievementGridSection: some View {
        let achievements = viewModel.achievements.filter { $0.category == selectedCategory }
        let columns = [
            GridItem(.flexible(), spacing: AppTheme.Spacing.md),
            GridItem(.flexible(), spacing: AppTheme.Spacing.md),
            GridItem(.flexible(), spacing: AppTheme.Spacing.md)
        ]
        
        return LazyVGrid(columns: columns, spacing: AppTheme.Spacing.md) {
            ForEach(achievements) { achievement in
                achievementBadgeCell(achievement)
            }
        }
    }
    
    func achievementBadgeCell(_ achievement: Achievement) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: AppTheme.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(Color(hex: achievement.color).opacity(0.15))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: achievement.icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Color(hex: achievement.color))
                }
                
                Text(achievement.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if !achievement.isUnlocked && achievement.progress > 0 {
                    Text("\(achievement.progressPercentage)%")
                        .font(.captionSmall)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.sm)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
            .opacity(achievement.isUnlocked ? 1.0 : 0.65)
            
            // Unlock badge
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.success)
                    .background(Circle().fill(AppColors.background).frame(width: 24, height: 24))
                    .offset(x: 4, y: -4)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func requirement(_ achievement: Achievement) -> String {
        switch achievement.requirement {
        case .scanCount:
            return "scans"
        case .streakDays:
            return "days"
        case .xpPoints:
            return "XP"
        case .brushingTime:
            return "mins"
        case .consistentDays:
            return "days"
        case .perfectionCount:
            return "scans"
        }
    }
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let rgb = Int(hex, radix: 16) ?? 0
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

// MARK: - Achievement Category All Cases

extension AchievementCategory: CaseIterable {
    static var allCases: [AchievementCategory] {
        [.getting_started, .streaks, .perfection, .consistency, .learning, .social, .special]
    }
}