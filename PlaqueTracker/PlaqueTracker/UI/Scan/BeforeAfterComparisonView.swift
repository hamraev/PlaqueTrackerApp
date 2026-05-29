//
//  BeforeAfterComparisonView.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import SwiftUI

struct BeforeAfterComparisonView: View {
    let session: ScanPhotoSession
    @ObservedObject var viewModel: LiveScanViewModel
    @ObservedObject var dashboardVM: AppDashboardViewModel
    let onStartNewScan: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showingAfter = false
    @State private var revealProgress = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                progressMessage

                if session.hasAfterPhoto {
                    sideBySideComparison
                    toggleComparison
                } else {
                    missingAfterState
                }

                PhotoProgressCard(
                    totalScans: viewModel.totalScans,
                    completedSessions: viewModel.completedSessions,
                    improvementScore: session.improvementScore ?? viewModel.averageImprovement,
                    streakDays: dashboardVM.streakDays
                )

                Button {
                    onStartNewScan()
                } label: {
                    Label("Start Another Smile Scan", systemImage: "camera.fill")
                        .primaryButtonStyle()
                }

                NavigationLink {
                    LearnView()
                } label: {
                    Label("Learn One Tip", systemImage: "book.fill")
                        .secondaryButtonStyle()
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .navigationTitle("Compare My Smile")
        .background(AppColors.background)
        .onAppear {
            AppFeedbackManager.shared.brushingMissionCompleted()
            guard !reduceMotion else {
                revealProgress = true
                return
            }
            withAnimation(AppTheme.Animation.spring.delay(0.12)) {
                revealProgress = true
            }
        }
    }
}

private extension BeforeAfterComparisonView {
    var progressMessage: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(AppColors.accent)
                .scaleEffect(revealProgress ? 1.0 : 0.78)
                .opacity(revealProgress ? 1.0 : 0.2)

            Text("Great job!")
                .font(AppTheme.headline1)

            Text(messageText)
                .font(AppTheme.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.lg)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.accent.opacity(0.12), AppColors.success.opacity(0.08)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
        .opacity(revealProgress ? 1.0 : 0.4)
    }

    var messageText: String {
        if let before = session.plaqueZonesBefore, let after = session.plaqueZonesAfter {
            let cleaned = max(before - after, 0)
            return cleaned > 0 ? "You cleaned \(cleaned) red zones. Your smile mission is complete!" : "You finished your brushing mission. Keep practicing those red spots!"
        }

        return "You finished your brushing mission. Compare your photos and keep the streak going!"
    }

    var sideBySideComparison: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            comparisonPhoto(title: "Before", path: session.beforePhotoPath)
            comparisonPhoto(title: "After", path: session.afterPhotoPath)
        }
    }

    var toggleComparison: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            ScanPhotoImage(data: viewModel.loadPhotoData(path: showingAfter ? session.afterPhotoPath : session.beforePhotoPath))
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
                .transition(.opacity)
                .animation(reduceMotion ? nil : AppTheme.Animation.smooth, value: showingAfter)

            Picker("Compare", selection: $showingAfter) {
                Text("Before").tag(false)
                Text("After").tag(true)
            }
            .pickerStyle(.segmented)
        }
        .padding(AppTheme.Spacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }

    var missingAfterState: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            ScanPhotoImage(data: viewModel.loadPhotoData(path: session.beforePhotoPath))
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))

            Text("Take an after photo to finish this mission.")
                .font(AppTheme.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppTheme.Spacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }

    func comparisonPhoto(title: String, path: String?) -> some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            ScanPhotoImage(data: viewModel.loadPhotoData(path: path))
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md))

            Text(title)
                .font(AppTheme.captionBold)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.sm)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }
}
