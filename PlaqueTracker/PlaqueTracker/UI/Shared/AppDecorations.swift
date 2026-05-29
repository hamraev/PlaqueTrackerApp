//
//  AppDecorations.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import SwiftUI

struct BubbleBackground: View {
    var body: some View {
        OptionalAssetImage(name: "BG_HomeBubbles", contentMode: .fill) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [AppColors.primary.opacity(0.10), AppColors.info.opacity(0.05), AppColors.background]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                ForEach(0..<14, id: \.self) { index in
                    Circle()
                        .stroke(AppColors.info.opacity(0.15), lineWidth: 1.5)
                        .frame(width: CGFloat(18 + (index % 5) * 14), height: CGFloat(18 + (index % 5) * 14))
                        .offset(x: CGFloat((index * 53) % 320) - 150, y: CGFloat((index * 79) % 700) - 320)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ToothPatternBackground: View {
    var body: some View {
        OptionalAssetImage(name: "BG_MissionToothPattern", contentMode: .fill) {
            GeometryReader { geometry in
                ZStack {
                    AppColors.cardBackground

                    ForEach(0..<18, id: \.self) { index in
                        Image(systemName: "mouth.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primary.opacity(0.07))
                            .rotationEffect(.degrees(index.isMultiple(of: 2) ? -12 : 12))
                            .position(
                                x: CGFloat((index * 67) % max(Int(geometry.size.width), 1)),
                                y: CGFloat((index * 43) % max(Int(geometry.size.height), 1))
                            )
                    }
                }
            }
        }
    }
}

struct ConfettiBackground: View {
    var body: some View {
        OptionalAssetImage(name: "BG_RewardsConfetti", contentMode: .fill) {
            ZStack {
                AppColors.background

                ForEach(0..<36, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(confettiColor(index))
                        .frame(width: 6, height: 12)
                        .rotationEffect(.degrees(Double((index * 31) % 180)))
                        .offset(x: CGFloat((index * 41) % 360) - 180, y: CGFloat((index * 59) % 760) - 360)
                        .opacity(0.22)
                }
            }
        }
        .ignoresSafeArea()
    }

    private func confettiColor(_ index: Int) -> Color {
        [AppColors.primary, AppColors.success, AppColors.accent, AppColors.info, AppColors.warning][index % 5]
    }
}

struct ScienceLabBackground: View {
    var body: some View {
        OptionalAssetImage(name: "BG_LearnScienceLab", contentMode: .fill) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [AppColors.info.opacity(0.10), AppColors.success.opacity(0.05), AppColors.background]),
                    startPoint: .top,
                    endPoint: .bottom
                )

                ForEach(0..<12, id: \.self) { index in
                    Image(systemName: index.isMultiple(of: 2) ? "testtube.2" : "atom")
                        .font(.system(size: index.isMultiple(of: 3) ? 30 : 20, weight: .semibold))
                        .foregroundColor((index.isMultiple(of: 2) ? AppColors.success : AppColors.info).opacity(0.10))
                        .rotationEffect(.degrees(Double((index * 23) % 90) - 45))
                        .offset(x: CGFloat((index * 71) % 340) - 170, y: CGFloat((index * 97) % 720) - 350)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct HappyToothEmptyState: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            OptionalAssetImage(name: "Empty_HappyTooth", contentMode: .fit) {
                ZStack {
                    Circle()
                        .fill(AppColors.info.opacity(0.14))
                        .frame(width: 112, height: 112)

                    Image(systemName: "mouth.fill")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundColor(AppColors.primary)

                    Image(systemName: "sparkles")
                        .foregroundColor(AppColors.accent)
                        .offset(x: 40, y: -32)
                }
            }
            .frame(width: 132, height: 132)

            Text(title)
                .font(AppTheme.headline2)
                .multilineTextAlignment(.center)

            Text(message)
                .font(AppTheme.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.xl)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }
}

struct GymBadgeView: View {
    let icon: String
    let color: Color
    let isUnlocked: Bool
    var assetName: String?
    var size: CGFloat = 70

    var body: some View {
        OptionalAssetImage(name: assetName ?? "", contentMode: .fit) {
            ZStack {
                badgeShape
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                isUnlocked ? color.opacity(0.95) : AppColors.disabled,
                                isUnlocked ? color.opacity(0.55) : AppColors.disabled.opacity(0.65)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        badgeShape
                            .stroke(isUnlocked ? Color.white.opacity(0.7) : AppColors.textTertiary.opacity(0.25), lineWidth: 3)
                    )
                    .shadow(color: color.opacity(isUnlocked ? 0.25 : 0.0), radius: 8, x: 0, y: 4)

                Circle()
                    .fill(Color.white.opacity(isUnlocked ? 0.22 : 0.12))
                    .frame(width: size * 0.58, height: size * 0.58)

                Image(systemName: icon)
                    .font(.system(size: size * 0.36, weight: .bold))
                    .foregroundColor(isUnlocked ? .white : AppColors.textTertiary)
            }
        }
        .frame(width: size, height: size)
        .saturation(isUnlocked ? 1.0 : 0.0)
        .opacity(isUnlocked ? 1.0 : 0.58)
        .accessibilityHidden(true)
    }

    private var badgeShape: some Shape {
        RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
    }
}
