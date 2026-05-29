//
//  ReusableCards.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 3/5/26.
//

import SwiftUI

// MARK: - Stats Card

/// Displays a statistic with icon, value, and label
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    var isLarge: Bool = false
    
    var body: some View {
        VStack(spacing: isLarge ? AppTheme.Spacing.md : AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: isLarge ? 32 : 24, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(isLarge ? AppTheme.headline2 : AppTheme.headline3)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.md)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }
}

// MARK: - Achievement Badge

/// Displays a badge/achievement with icon, title, and description
struct AchievementBadge: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(AppTheme.headline3)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            if !isUnlocked {
                Text("Locked")
                    .font(.captionBold)
                    .foregroundColor(AppColors.textTertiary)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.vertical, 4)
                    .background(AppColors.disabled)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}

// MARK: - Progress Card

/// Displays progress with title, percentage, and progress bar
struct ProgressCard: View {
    let title: String
    let current: Int
    let total: Int
    let color: Color
    
    var progress: Double {
        total > 0 ? Double(current) / Double(total) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text(title)
                    .font(AppTheme.headline3)
                Spacer()
                Text("\(current)/\(total)")
                    .font(AppTheme.bodyBold)
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm)
                        .fill(color.opacity(0.15))
                    
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm)
                        .fill(color)
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 8)
        }
        .padding(AppTheme.Spacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }
}

// MARK: - Streak Card

/// Displays current streak with flame icon and bonus info
struct StreakCard: View {
    let current: Int
    let best: Int
    let onTap: () -> Void = {}
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: AppTheme.Spacing.md) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current Streak")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("\(current) days")
                            .font(AppTheme.headline2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.text)
                    }
                    
                    Spacer()
                    
                    if current > 0 {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.success)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Personal Best: \(best) days")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    Image(systemName: "star.fill")
                        .foregroundColor(AppColors.accent)
                }
            }
            .padding(AppTheme.Spacing.md)
            .background(LinearGradient(
                gradient: Gradient(colors: [AppColors.accent.opacity(0.1), AppColors.accent.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
        }
    }
}

// MARK: - XP Display Card

/// Shows XP progress toward next level
struct XPCard: View {
    let currentXP: Int
    let xpToNextLevel: Int
    let level: Int
    
    var progress: Double {
        xpToNextLevel > 0 ? Double(currentXP) / Double(xpToNextLevel) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level \(level)")
                        .font(AppTheme.headline3)
                    
                    Text("\(currentXP) / \(xpToNextLevel) XP")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppColors.primary.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(AppColors.primary, lineWidth: 4)
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption2)
                        .fontWeight(.bold)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(LinearGradient(
            gradient: Gradient(colors: [AppColors.primary.opacity(0.05), AppColors.primary.opacity(0.02)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }
}

// MARK: - Tip Card

/// Displays helpful tips with icon and action button
struct TipCard: View {
    let icon: String
    let title: String
    let description: String
    let actionText: String
    let actionColor: Color
    let onAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(actionColor)
                    .frame(width: 44, height: 44)
                    .background(actionColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppTheme.headline3)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            Button(action: onAction) {
                HStack {
                    Text(actionText)
                        .font(AppTheme.bodyBold)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, AppTheme.Spacing.sm)
                .foregroundColor(.white)
                .background(actionColor)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md))
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }
}

// MARK: - Empty State View

/// Shows when no data is available
struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    let actionText: String?
    let onAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                Text(title)
                    .font(AppTheme.headline2)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionText = actionText, let onAction = onAction {
                Button(action: onAction) {
                    Text(actionText)
                        .primaryButtonStyle()
                }
            }
        }
        .padding(AppTheme.Spacing.xl)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#if DEBUG
struct ReusableCardsPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Stats Card
                VStack(alignment: .leading) {
                    Text("Stats Card").font(AppTheme.headline3)
                    HStack(spacing: AppTheme.Spacing.md) {
                        StatCard(icon: "flame.fill", value: "5", label: "Streak", color: .orange)
                        StatCard(icon: "star.fill", value: "120", label: "XP", color: AppColors.primary)
                    }
                }
                
                // Streak Card
                VStack(alignment: .leading) {
                    Text("Streak Card").font(AppTheme.headline3)
                    StreakCard(current: 5, best: 12)
                }
                
                // XP Card
                VStack(alignment: .leading) {
                    Text("XP Card").font(AppTheme.headline3)
                    XPCard(currentXP: 850, xpToNextLevel: 1000, level: 3)
                }
                
                // Progress Card
                VStack(alignment: .leading) {
                    Text("Progress Card").font(AppTheme.headline3)
                    ProgressCard(title: "Daily Goal", current: 3, total: 3, color: AppColors.success)
                }
                
                // Achievement Badge
                VStack(alignment: .leading) {
                    Text("Achievement Badges").font(AppTheme.headline3)
                    HStack(spacing: AppTheme.Spacing.md) {
                        AchievementBadge(
                            icon: "star.fill",
                            title: "First Scan",
                            subtitle: "Do your first scan",
                            color: AppColors.accent,
                            isUnlocked: true
                        )
                        
                        AchievementBadge(
                            icon: "flame.fill",
                            title: "Week Warrior",
                            subtitle: "7-day streak",
                            color: .orange,
                            isUnlocked: false
                        )
                    }
                }
                
                // Tip Card
                VStack(alignment: .leading) {
                    Text("Tip Card").font(AppTheme.headline3)
                    TipCard(
                        icon: "lightbulb.fill",
                        title: "Brush Twice Daily",
                        description: "Brush your teeth for 2 minutes in the morning and evening",
                        actionText: "Learn More",
                        actionColor: AppColors.info
                    ) {
                        print("Action tapped")
                    }
                }
                
                // Empty State
                VStack(alignment: .leading) {
                    Text("Empty State").font(AppTheme.headline3)
                    EmptyStateView(
                        icon: "checkmark.circle.fill",
                        title: "All Done!",
                        description: "Come back tomorrow to continue your streak",
                        actionText: nil,
                        onAction: nil
                    )
                }
            }
            .padding(AppTheme.Spacing.md)
        }
    }
}

#Preview {
    ReusableCardsPreview()
}
#endif
