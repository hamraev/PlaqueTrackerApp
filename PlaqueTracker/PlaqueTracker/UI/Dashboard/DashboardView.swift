import SwiftUI

struct DashboardView: View {
    @State private var smileScore = 82
    @State private var streakDays = 5
    @State private var xpPoints = 120
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                headerCard
                statsRow
                StreakCard(current: streakDays, best: 12)
                XPCard(currentXP: xpPoints, xpToNextLevel: 1000, level: 3)
                startScanButton
            }
            .padding(AppTheme.Spacing.md)
        }
        .navigationTitleAppTheme.Spacing.md) {
            Text("Great job today!")
                .font(AppTheme.headline1)
                .multilineTextAlignment(.center)

            Text("Your smile looks fantastic. Let's keep the momentum going!")
                .font(AppTheme.bodySmall)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)

            ZStack {
                Circle()
                    .fill(Color.scoreColor(for: smileScore).opacity(0.15))
                    .frame(width: 140, height: 140)

                VStack(spacing: 4) {
                    Text("\(smileScore)")
                        .font(AppTheme.display2)
                        .foregroundColor(Color.scoreColor(for: smileScore))
                    
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
                    Color.scoreColor(for: smileScore).opacity(0.08),
                    Color.scoreColor(for: smileScore).opacity(0.03)
                ]),AppTheme.Spacing.md) {
            StatCard(
                icon: "flame.fill",
                value: "\(streakDays)d",
                label: "Streak",
                color: .orange,
                isLarge: false
            )
            
            StatCard(
                icon: "star.fill",
                value: "\(xpPoints)",
                label: "XP",
                color: AppColors.primary,
                isLarge: false
            )
            
            StatCard(
                icon: "crown.fill",
                value: "3",
                label: "Level",
                color: AppColors.accent,
                isLarge: false
            )
        }statCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)

            Text(value)
                .font(.title3.bold())

            Text(title)
                .font(.subheadline)
              (action: {}) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "dot.radiowaves.left.and.right")
                Text("Start Scan")
                    .font(AppTheme.bodyBold)
            }
            .primaryButtonStyle(
        } label: {
            HStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                Text("Start Scan")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
