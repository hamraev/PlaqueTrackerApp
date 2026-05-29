//
//  LearnView.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 3/5/26.
//

import Combine
import SwiftUI

struct LearnView: View {
    @StateObject private var viewModel = LearnViewModel()
    @State private var selectedLesson: LearnLesson?

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                progressHeader

                ForEach(viewModel.sections) { section in
                    lessonSection(section)
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .navigationTitle("Learn")
        .background(ScienceLabBackground())
        .sheet(item: $selectedLesson) { lesson in
            lessonDetail(lesson)
        }
    }
}

private extension LearnView {
    var progressHeader: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.md) {
                learningIllustration(kind: .hero, color: AppColors.primary)
                    .frame(width: 72, height: 72)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Learning Progress")
                        .font(AppTheme.headline2)

                    Text("\(viewModel.completedCount) of \(viewModel.totalCount) lessons read")
                        .font(AppTheme.bodySmall)
                        .foregroundColor(AppColors.textSecondary)
                }

                Spacer()

                Text("\(viewModel.progressPercent)%")
                    .font(AppTheme.headline2)
                    .foregroundColor(AppColors.primary)
            }

            ProgressCard(
                title: "Healthy Smile Basics",
                current: viewModel.completedCount,
                total: viewModel.totalCount,
                color: AppColors.primary
            )
        }
    }

    func lessonSection(_ section: LearnSection) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: section.icon)
                    .foregroundColor(section.color)

                Text(section.title)
                    .font(AppTheme.headline2)
            }

            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(section.lessons) { lesson in
                    lessonCard(lesson, sectionColor: section.color)
                }
            }
        }
    }

    func lessonCard(_ lesson: LearnLesson, sectionColor: Color) -> some View {
        let isCompleted = viewModel.isCompleted(lesson)

        return Button {
            selectedLesson = lesson
        } label: {
            HStack(spacing: AppTheme.Spacing.md) {
                learningIllustration(kind: lesson.illustration, color: sectionColor)
                    .frame(width: 58, height: 58)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Text(lesson.title)
                            .font(AppTheme.headline3)
                            .foregroundColor(AppColors.text)
                            .multilineTextAlignment(.leading)

                        if isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppColors.success)
                        }
                    }

                    Text(lesson.summary)
                        .font(AppTheme.bodySmall)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    Text("\(lesson.minutes) min read")
                        .font(AppTheme.captionSmall)
                        .foregroundColor(AppColors.textTertiary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(AppTheme.captionBold)
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(AppTheme.Spacing.md)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg)
                    .stroke(isCompleted ? AppColors.success.opacity(0.45) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    func lessonDetail(_ lesson: LearnLesson) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    learningIllustration(kind: lesson.illustration, color: lesson.color)
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text(lesson.title)
                            .font(AppTheme.headline1)

                        Text(lesson.summary)
                            .font(AppTheme.body)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        ForEach(lesson.points, id: \.self) { point in
                            HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(lesson.color)
                                    .padding(.top, 2)

                                Text(point)
                                    .font(AppTheme.body)
                                    .foregroundColor(AppColors.text)
                            }
                        }
                    }

                    Button {
                        viewModel.markCompleted(lesson)
                        selectedLesson = nil
                    } label: {
                        Label(
                            viewModel.isCompleted(lesson) ? "Read Again" : "Mark as Read",
                            systemImage: viewModel.isCompleted(lesson) ? "arrow.clockwise" : "checkmark"
                        )
                        .primaryButtonStyle()
                    }
                }
                .padding(AppTheme.Spacing.md)
            }
            .navigationTitle("Lesson")
            .platformInlineNavigationTitle()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        selectedLesson = nil
                    }
                }
            }
        }
    }

    @ViewBuilder
    func learningIllustration(kind: LessonIllustration, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md)
                .fill(color.opacity(0.12))

            Circle()
                .fill(color.opacity(0.12))
                .frame(width: kind == .hero ? 118 : 46, height: kind == .hero ? 118 : 46)
                .offset(x: kind == .hero ? 34 : 18, y: kind == .hero ? -24 : -12)

            Image(systemName: kind.icon)
                .font(.system(size: kind == .hero ? 54 : 28, weight: .semibold))
                .foregroundColor(color)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md))
    }
}

private extension View {
    @ViewBuilder
    func platformInlineNavigationTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}

private final class LearnViewModel: ObservableObject {
    @Published private(set) var completedLessonIDs: Set<String>

    let sections = LearnContent.sections
    private let storageKey = "PlaqueTracker.learn.completedLessonIDs"

    var totalCount: Int {
        sections.reduce(0) { $0 + $1.lessons.count }
    }

    var completedCount: Int {
        completedLessonIDs.count
    }

    var progressPercent: Int {
        guard totalCount > 0 else { return 0 }
        return min((completedCount * 100) / totalCount, 100)
    }

    init() {
        let saved = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        self.completedLessonIDs = Set(saved)
    }

    func isCompleted(_ lesson: LearnLesson) -> Bool {
        completedLessonIDs.contains(lesson.id)
    }

    func markCompleted(_ lesson: LearnLesson) {
        completedLessonIDs.insert(lesson.id)
        UserDefaults.standard.set(Array(completedLessonIDs), forKey: storageKey)
    }
}

private struct LearnSection: Identifiable {
    let id: String
    let title: String
    let icon: String
    let color: Color
    let lessons: [LearnLesson]
}

private struct LearnLesson: Identifiable {
    let id: String
    let title: String
    let summary: String
    let minutes: Int
    let illustration: LessonIllustration
    let color: Color
    let points: [String]
}

private enum LessonIllustration {
    case hero
    case timer
    case circles
    case gumline
    case food
    case rinse
    case scan
    case streak

    var icon: String {
        switch self {
        case .hero: return "graduationcap.fill"
        case .timer: return "timer"
        case .circles: return "circle.grid.2x2.fill"
        case .gumline: return "mouth.fill"
        case .food: return "fork.knife"
        case .rinse: return "drop.fill"
        case .scan: return "dot.radiowaves.left.and.right"
        case .streak: return "flame.fill"
        }
    }
}

private enum LearnContent {
    static let sections: [LearnSection] = [
        LearnSection(
            id: "brush",
            title: "Brush Better",
            icon: "sparkles",
            color: AppColors.primary,
            lessons: [
                LearnLesson(
                    id: "two_minutes",
                    title: "Two Minutes Matters",
                    summary: "Give every area enough time, especially the back teeth.",
                    minutes: 2,
                    illustration: .timer,
                    color: AppColors.primary,
                    points: [
                        "Brush for two full minutes, twice a day.",
                        "Split your mouth into four zones and spend about 30 seconds on each one.",
                        "Move slowly so the bristles can reach the tiny spaces where plaque builds up."
                    ]
                ),
                LearnLesson(
                    id: "small_circles",
                    title: "Small Circles Win",
                    summary: "Gentle circles clean better than fast scrubbing.",
                    minutes: 1,
                    illustration: .circles,
                    color: AppColors.primary,
                    points: [
                        "Use small circles along the tooth surface and gumline.",
                        "Press gently; hard pressure can bother gums and wear down enamel.",
                        "Angle the brush slightly toward the gums for a cleaner edge."
                    ]
                )
            ]
        ),
        LearnSection(
            id: "protect",
            title: "Protect Your Smile",
            icon: "shield.fill",
            color: AppColors.success,
            lessons: [
                LearnLesson(
                    id: "gumline",
                    title: "Do Not Skip the Gumline",
                    summary: "Plaque often hides right where teeth meet gums.",
                    minutes: 2,
                    illustration: .gumline,
                    color: AppColors.success,
                    points: [
                        "Brush the edge where each tooth meets the gums.",
                        "Use gentle pressure and short strokes on sensitive spots.",
                        "Tell a grown-up or dentist if gums bleed often."
                    ]
                ),
                LearnLesson(
                    id: "snack_smarter",
                    title: "Snack Smarter",
                    summary: "Sugary snacks can feed plaque for a long time.",
                    minutes: 1,
                    illustration: .food,
                    color: AppColors.success,
                    points: [
                        "Choose water after sweet or sticky snacks.",
                        "Crunchy fruits and vegetables can help rinse the mouth between brushes.",
                        "Keep candy and soda as sometimes foods, not all-day sips or nibbles."
                    ]
                ),
                LearnLesson(
                    id: "rinse_smart",
                    title: "Rinse Smart",
                    summary: "A little fluoride left behind keeps helping after brushing.",
                    minutes: 1,
                    illustration: .rinse,
                    color: AppColors.success,
                    points: [
                        "Spit out toothpaste after brushing.",
                        "Avoid rinsing with lots of water right away when using fluoride toothpaste.",
                        "Ask a dentist which rinse routine is best for your age and teeth."
                    ]
                )
            ]
        ),
        LearnSection(
            id: "tracker",
            title: "Use PlaqueTracker",
            icon: "star.fill",
            color: AppColors.accent,
            lessons: [
                LearnLesson(
                    id: "read_scan",
                    title: "Read Your Scan",
                    summary: "Use your score as a clue for where to brush next.",
                    minutes: 2,
                    illustration: .scan,
                    color: AppColors.accent,
                    points: [
                        "A scan is feedback, not a grade.",
                        "Start with the highlighted areas on the Brush Map.",
                        "Scan again after brushing to see what improved."
                    ]
                ),
                LearnLesson(
                    id: "build_streak",
                    title: "Build a Streak",
                    summary: "Small daily wins are the easiest way to build a strong habit.",
                    minutes: 1,
                    illustration: .streak,
                    color: AppColors.accent,
                    points: [
                        "Brush morning and night to keep the streak alive.",
                        "Celebrate progress even when the score is not perfect.",
                        "Use rewards as reminders that healthy habits are growing."
                    ]
                )
            ]
        )
    ]
}

#if DEBUG
#Preview {
    NavigationStack {
        LearnView()
    }
}
#endif
