//
//  PhotoProgressCard.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import SwiftUI

struct PhotoProgressCard: View {
    let totalScans: Int
    let completedSessions: Int
    let improvementScore: Int
    let streakDays: Int

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Smile Mission Progress")
                        .font(AppTheme.headline3)

                    Text(progressMessage)
                        .font(AppTheme.bodySmall)
                        .foregroundColor(AppColors.textSecondary)
                }

                Spacer()

                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(AppColors.success)
            }

            HStack(spacing: AppTheme.Spacing.sm) {
                StatCard(icon: "camera.fill", value: "\(totalScans)", label: "Scans", color: AppColors.primary)
                StatCard(icon: "checkmark.seal.fill", value: "\(completedSessions)", label: "Done", color: AppColors.success)
            }

            HStack(spacing: AppTheme.Spacing.sm) {
                StatCard(icon: "sparkles", value: "\(improvementScore)%", label: "Better", color: AppColors.accent)
                StatCard(icon: "flame.fill", value: "\(streakDays)d", label: "Streak", color: .orange)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }

    private var progressMessage: String {
        if totalScans == 0 {
            return "Start your first scan to begin the mission."
        }

        if completedSessions == 0 {
            return "Finish an after photo to compare your smile."
        }

        return "You are building a stronger brushing habit."
    }
}
