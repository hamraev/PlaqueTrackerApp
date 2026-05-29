//
//  PhotoGalleryView.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import SwiftUI

struct PhotoGalleryView: View {
    @ObservedObject var viewModel: LiveScanViewModel
    @ObservedObject var dashboardVM: AppDashboardViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                PhotoProgressCard(
                    totalScans: viewModel.totalScans,
                    completedSessions: viewModel.completedSessions,
                    improvementScore: viewModel.averageImprovement,
                    streakDays: dashboardVM.streakDays
                )

                if viewModel.sessions.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.sessions) { session in
                        NavigationLink {
                            BeforeAfterComparisonView(
                                session: session,
                                viewModel: viewModel,
                                dashboardVM: dashboardVM,
                                onStartNewScan: {}
                            )
                        } label: {
                            sessionCard(session)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .navigationTitle("Smile Gallery")
        .background(AppColors.background)
        .onAppear {
            viewModel.reload()
        }
    }
}

private extension PhotoGalleryView {
    var emptyState: some View {
        HappyToothEmptyState(
            title: "No smile scans yet",
            message: "Start your first scan and your before-and-after photos will appear here."
        )
    }

    func sessionCard(_ session: ScanPhotoSession) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(AppTheme.headline3)
                        .foregroundColor(AppColors.text)

                    Text(session.statusText)
                        .font(AppTheme.bodySmall)
                        .foregroundColor(session.isComplete ? AppColors.success : AppColors.warning)
                }

                Spacer()

                Image(systemName: session.isComplete ? "checkmark.seal.fill" : "clock.fill")
                    .foregroundColor(session.isComplete ? AppColors.success : AppColors.warning)
            }

            HStack(spacing: AppTheme.Spacing.md) {
                photoThumb(title: "Before", path: session.beforePhotoPath)
                photoThumb(title: "After", path: session.afterPhotoPath)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
        .shadowLight()
    }

    func photoThumb(title: String, path: String?) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            ScanPhotoImage(data: viewModel.loadPhotoData(path: path))
                .frame(height: 98)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm))

            Text(title)
                .font(AppTheme.captionBold)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}
