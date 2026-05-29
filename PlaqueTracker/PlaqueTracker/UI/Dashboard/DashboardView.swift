import SwiftUI

struct DashboardView: View {
    @StateObject private var dashboardVM = AppDashboardViewModel()
    @StateObject private var photoVM = LiveScanViewModel()
    @EnvironmentObject private var settings: AppSettings
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var scorePulse = false
    @State private var xpPulse = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                headerCard
                statsRow
                StreakCard(current: dashboardVM.streakDays, best: dashboardVM.bestStreak)
                XPCard(currentXP: dashboardVM.xpPoints, xpToNextLevel: dashboardVM.xpToNextLevel, level: dashboardVM.level)
                startScanButton
                galleryButton
            }
            .padding(AppTheme.Spacing.md)
        }
        .navigationTitle("Home")
        .background(BubbleBackground())
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .accessibilityLabel("Open Settings")
                }
            }
        }
        .onAppear {
            photoVM.reload()
        }
        .onChange(of: dashboardVM.smileScore) { _, _ in
            pulseScore()
        }
        .onChange(of: dashboardVM.xpPoints) { _, _ in
            pulseXP()
        }
    }

    private var headerCard: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Text("Hi, \(settings.childName)!")
                .font(AppTheme.headline1)
                .multilineTextAlignment(.center)

            Text("Your smile looks fantastic. Let's keep the momentum going!")
                .font(AppTheme.bodySmall)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)

            ZStack {
                Circle()
                    .fill(Color.scoreColor(for: dashboardVM.smileScore).opacity(0.15))
                    .frame(width: 140, height: 140)

                VStack(spacing: 4) {
                    Text("\(dashboardVM.smileScore)")
                        .font(AppTheme.display2)
                        .foregroundColor(Color.scoreColor(for: dashboardVM.smileScore))
                        .contentTransition(.numericText())
                        .scaleEffect(scorePulse ? 1.12 : 1.0)
                        .animation(reduceMotion ? nil : AppTheme.Animation.spring, value: scorePulse)

                    Text("Smile Score")
                        .font(AppTheme.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.md)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.scoreColor(for: dashboardVM.smileScore).opacity(0.08),
                    Color.scoreColor(for: dashboardVM.smileScore).opacity(0.03)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }

    private var statsRow: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            StatCard(icon: "flame.fill", value: "\(dashboardVM.streakDays)d", label: "Streak", color: .orange)
            StatCard(icon: "star.fill", value: "\(dashboardVM.xpPoints)", label: "XP", color: AppColors.primary)
                .scaleEffect(xpPulse ? 1.04 : 1.0)
                .animation(reduceMotion ? nil : AppTheme.Animation.spring, value: xpPulse)
            StatCard(icon: "crown.fill", value: "\(dashboardVM.level)", label: "Level", color: AppColors.accent)
        }
    }

    private var startScanButton: some View {
        NavigationLink {
            LiveScanView(dashboardVM: dashboardVM)
        } label: {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "dot.radiowaves.left.and.right")
                Text("Start Smile Scan")
            }
            .primaryButtonStyle()
        }
    }

    private var galleryButton: some View {
        NavigationLink {
            PhotoGalleryView(viewModel: photoVM, dashboardVM: dashboardVM)
        } label: {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(AppColors.accent)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Smile Photo Gallery")
                        .font(AppTheme.headline3)
                        .foregroundColor(AppColors.text)

                    Text(photoVM.totalScans == 0 ? "No smile scans yet. Start your first scan!" : "Compare your brushing progress")
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

    private func pulseScore() {
        guard !reduceMotion else { return }
        scorePulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            scorePulse = false
        }
    }

    private func pulseXP() {
        guard !reduceMotion else { return }
        xpPulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            xpPulse = false
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        DashboardView()
    }
}
#endif
