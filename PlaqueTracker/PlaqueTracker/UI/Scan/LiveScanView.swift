//
//  LiveScanView.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 3/5/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct LiveScanView: View {
    @ObservedObject var dashboardVM: AppDashboardViewModel
    @StateObject private var viewModel = LiveScanViewModel()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showingCamera = false
    @State private var cameraTarget: PhotoTarget = .before
    @State private var showingGallery = false
    @State private var completionPulse = false
    private let rewardsViewModel = RewardsViewModel()

    @MainActor
    init() {
        self._dashboardVM = ObservedObject(wrappedValue: AppDashboardViewModel())
    }

    @MainActor
    init(dashboardVM: AppDashboardViewModel) {
        self._dashboardVM = ObservedObject(wrappedValue: dashboardVM)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                missionHeader
                actionCard
                scanProgressCard
                galleryButton
            }
            .padding(AppTheme.Spacing.md)
        }
        .navigationTitle("Scan")
        .background(AppColors.background)
        .navigationDestination(isPresented: $showingGallery) {
            PhotoGalleryView(viewModel: viewModel, dashboardVM: dashboardVM)
        }
        .navigationDestination(isPresented: comparisonBinding) {
            if let session = viewModel.currentSession {
                BeforeAfterComparisonView(
                    session: session,
                    viewModel: viewModel,
                    dashboardVM: dashboardVM,
                    onStartNewScan: {
                        viewModel.resetMission()
                    }
                )
            }
        }
        #if os(iOS)
        .sheet(isPresented: $showingCamera) {
            CameraCaptureView(sourceType: UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary) { imageData in
                handlePhotoData(imageData, target: cameraTarget)
            }
        }
        #endif
        .onAppear {
            viewModel.reload()
        }
        .animation(reduceMotion ? nil : AppTheme.Animation.smooth, value: viewModel.missionStep)
    }
}

private extension LiveScanView {
    var comparisonBinding: Binding<Bool> {
        Binding(
            get: { viewModel.missionStep == .compare && viewModel.currentSession?.isComplete == true },
            set: { isActive in
                if !isActive, viewModel.missionStep == .compare {
                    viewModel.resetMission()
                }
            }
        )
    }

    var missionHeader: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(AppColors.primary.opacity(0.14))
                        .frame(width: 78, height: 78)

                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.missionStep.title)
                        .font(AppTheme.headline1)
                        .foregroundColor(AppColors.text)

                    Text(viewModel.missionStep.message)
                        .font(AppTheme.bodySmall)
                        .foregroundColor(AppColors.textSecondary)
                }

                Spacer()
            }

            missionSteps
        }
        .padding(AppTheme.Spacing.md)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.primary.opacity(0.08), AppColors.success.opacity(0.06)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }

    var missionSteps: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ForEach(PhotoMissionStep.allCases, id: \.self) { step in
                VStack(spacing: 4) {
                    Image(systemName: step.icon)
                        .font(.system(size: 15, weight: .semibold))
                    Text(step.shortTitle)
                        .font(AppTheme.captionSmall)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(step.isActive(for: viewModel.missionStep) ? .white : AppColors.textSecondary)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(step.isActive(for: viewModel.missionStep) ? step.color : AppColors.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.sm))
            }
        }
    }

    var actionCard: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            if let message = viewModel.permissionMessage {
                Text(message)
                    .font(AppTheme.bodySmall)
                    .foregroundColor(AppColors.warning)
                    .multilineTextAlignment(.center)
            }

            switch viewModel.missionStep {
            case .takeBefore:
                scanPhotoPrompt(
                    title: "Take Before Photo",
                    subtitle: "Smile at the camera before brushing. This starts your mission.",
                    icon: "1.circle.fill",
                    color: AppColors.primary
                )

                photoCaptureButtons(target: .before)

            case .brushRedSpots:
                scanPhotoPrompt(
                    title: "Brush Red Spots",
                    subtitle: "Follow the Brush Map, then come back for your after photo.",
                    icon: "mouth.fill",
                    color: AppColors.warning
                )

                NavigationLink {
                    BrushMapView(dashboardVM: dashboardVM)
                } label: {
                    Label("Go to Brush Map", systemImage: "arrow.right.circle.fill")
                        .primaryButtonStyle()
                }

                Button {
                    updateMissionStep(.takeAfter)
                } label: {
                    Label("I Brushed the Red Spots", systemImage: "checkmark.circle.fill")
                        .secondaryButtonStyle()
                }

            case .takeAfter:
                scanPhotoPrompt(
                    title: "Take After Photo",
                    subtitle: "Take one more smile photo so we can compare your progress.",
                    icon: "2.circle.fill",
                    color: AppColors.success
                )

                photoCaptureButtons(target: .after)

            case .compare:
                scanPhotoPrompt(
                    title: "Great job!",
                    subtitle: "Your comparison is ready. Let’s see your progress.",
                    icon: "star.circle.fill",
                    color: AppColors.accent
                )

                if let session = viewModel.currentSession {
                    NavigationLink {
                        BeforeAfterComparisonView(
                            session: session,
                            viewModel: viewModel,
                            dashboardVM: dashboardVM,
                            onStartNewScan: {
                                viewModel.resetMission()
                            }
                        )
                    } label: {
                        Label("Compare My Smile", systemImage: "rectangle.split.2x1.fill")
                            .primaryButtonStyle()
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(ToothPatternBackground())
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
        .shadowMedium()
    }

    var scanProgressCard: some View {
        PhotoProgressCard(
            totalScans: viewModel.totalScans,
            completedSessions: viewModel.completedSessions,
            improvementScore: viewModel.averageImprovement,
            streakDays: dashboardVM.streakDays
        )
    }

    var galleryButton: some View {
        Button {
            showingGallery = true
        } label: {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(AppColors.accent)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Smile Photo Gallery")
                        .font(AppTheme.headline3)
                        .foregroundColor(AppColors.text)

                    Text(viewModel.totalScans == 0 ? "No smile scans yet. Start your first scan!" : "See your smile progress")
                        .font(AppTheme.bodySmall)
                        .foregroundColor(AppColors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(AppTheme.Spacing.md)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
        }
        .buttonStyle(.plain)
    }

    func scanPhotoPrompt(title: String, subtitle: String, icon: String, color: Color) -> some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 42, weight: .bold))
                .foregroundColor(color)
                .scaleEffect(completionPulse ? 1.16 : 1.0)
                .animation(reduceMotion ? nil : AppTheme.Animation.spring, value: completionPulse)

            VStack(spacing: AppTheme.Spacing.sm) {
                Text(title)
                    .font(AppTheme.headline2)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(AppTheme.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }

    func photoCaptureButtons(target: PhotoTarget) -> some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Button {
                startCamera(target: target)
            } label: {
                Label(target == .before ? "Take Before Photo" : "Take After Photo", systemImage: "camera.fill")
                    .primaryButtonStyle()
            }

            Button {
                saveMockPhoto(target: target)
            } label: {
                Label("Use Sample Smile Photo", systemImage: "wand.and.stars")
                    .secondaryButtonStyle()
            }
        }
    }

    func startCamera(target: PhotoTarget) {
        cameraTarget = target
        viewModel.requestCameraAccess { granted in
            #if os(iOS)
            if granted || UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                showingCamera = true
            }
            #endif
        }
    }

    func handlePhotoData(_ data: Data, target: PhotoTarget) {
        switch target {
        case .before:
            dashboardVM.startScan()
            viewModel.saveBeforePhoto(data: data, plaqueScore: 100 - dashboardVM.smileScore)
            AppFeedbackManager.shared.scanCompleted()
            pulseCompletion()
        case .after:
            dashboardVM.stopScan()
            rewardsViewModel.apply(snapshot: dashboardVM.completeScan())
            viewModel.saveAfterPhoto(data: data, plaqueScore: max(100 - dashboardVM.smileScore - 24, 0))
            AppFeedbackManager.shared.brushingMissionCompleted()
            pulseCompletion()
        }
    }

    func saveMockPhoto(target: PhotoTarget) {
        #if canImport(UIKit)
        let data = viewModel.makeMockPhotoData(
            label: target == .before ? "Before" : "After",
            color: target == .before ? UIColor.systemPink : UIColor.systemGreen
        )
        #else
        let data = viewModel.makeMockPhotoData(label: target == .before ? "Before" : "After")
        #endif
        handlePhotoData(data, target: target)
    }

    func updateMissionStep(_ step: LiveScanViewModel.MissionStep) {
        if reduceMotion {
            viewModel.missionStep = step
        } else {
            withAnimation(AppTheme.Animation.smooth) {
                viewModel.missionStep = step
            }
        }
    }

    func pulseCompletion() {
        guard !reduceMotion else { return }
        completionPulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            completionPulse = false
        }
    }
}

private enum PhotoTarget {
    case before
    case after
}

private enum PhotoMissionStep: CaseIterable {
    case scan
    case brush
    case compare
    case reward

    var shortTitle: String {
        switch self {
        case .scan: return "Scan"
        case .brush: return "Brush"
        case .compare: return "Compare"
        case .reward: return "Reward"
        }
    }

    var icon: String {
        switch self {
        case .scan: return "camera.fill"
        case .brush: return "mouth.fill"
        case .compare: return "rectangle.split.2x1.fill"
        case .reward: return "star.fill"
        }
    }

    var color: Color {
        switch self {
        case .scan: return AppColors.primary
        case .brush: return AppColors.warning
        case .compare: return AppColors.success
        case .reward: return AppColors.accent
        }
    }

    func isActive(for step: LiveScanViewModel.MissionStep) -> Bool {
        switch (self, step) {
        case (.scan, .takeBefore), (.brush, .brushRedSpots), (.compare, .takeAfter), (.reward, .compare):
            return true
        default:
            return false
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        LiveScanView()
    }
}
#endif
