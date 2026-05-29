//
//  SettingsView.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    @StateObject private var reminderScheduler = ReminderScheduler()
    @StateObject private var photoVM = LiveScanViewModel()
    @State private var showResetConfirmation = false

    var body: some View {
        Form {
            Section("Smile Star") {
                TextField("Nickname", text: $settings.childName)
                    .textContentType(.nickname)
                    .accessibilityLabel("Child nickname")

                Picker("App Look", selection: $settings.colorMode) {
                    ForEach(AppColorMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
            }

            Section("Friendly Reminders") {
                Toggle("Smile mission reminder", isOn: reminderBinding)

                DatePicker("Reminder time", selection: reminderDateBinding, displayedComponents: .hourAndMinute)
                    .disabled(!settings.reminderEnabled)

                if let message = reminderScheduler.permissionMessage {
                    Text(message)
                        .font(AppTheme.caption)
                        .foregroundColor(AppColors.warning)
                }
            }

            Section("Sounds and Wiggles") {
                Toggle("Sound effects", isOn: $settings.soundEnabled)
                Toggle("Haptics", isOn: $settings.hapticsEnabled)
            }

            Section("Demo Mode") {
                Button {
                    photoVM.addDemoSession()
                    AppFeedbackManager.shared.scanCompleted()
                } label: {
                    Label("Add Sample Smile Scan", systemImage: "wand.and.stars")
                }

                Button(role: .destructive) {
                    showResetConfirmation = true
                } label: {
                    Label("Reset Demo Data", systemImage: "trash")
                }

                Text("PlaqueTracker works without Arduino hardware by using mock scan results in the simulator.")
                    .font(AppTheme.caption)
                    .foregroundColor(AppColors.textSecondary)
            }

            Section("About PlaqueTracker") {
                Label("Photos and scan data are stored locally for now.", systemImage: "lock.fill")
                Label("PlaqueTracker supports brushing habits and does not diagnose medical conditions.", systemImage: "heart.text.square.fill")
            }
        }
        .navigationTitle("Settings")
        .alert("Reset demo data?", isPresented: $showResetConfirmation) {
            Button("Reset", role: .destructive) {
                resetDemoData()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This clears saved sample photos, scan counters, learning progress, and achievements on this device.")
        }
        .onAppear {
            reminderScheduler.refreshStatus()
        }
    }

    private var reminderBinding: Binding<Bool> {
        Binding(
            get: { settings.reminderEnabled },
            set: { isEnabled in
                settings.reminderEnabled = isEnabled
                if isEnabled {
                    reminderScheduler.requestAndSchedule(at: settings.reminderDate)
                } else {
                    reminderScheduler.cancelReminder()
                }
            }
        )
    }

    private var reminderDateBinding: Binding<Date> {
        Binding(
            get: { settings.reminderDate },
            set: { date in
                settings.reminderDate = date
                if settings.reminderEnabled {
                    reminderScheduler.requestAndSchedule(at: date)
                }
            }
        )
    }

    private func resetDemoData() {
        let keys = [
            "PlaqueTracker.achievements.v1",
            "PlaqueTracker.learn.completedLessonIDs",
            "PlaqueTracker.dashboard.scanCount",
            "PlaqueTracker.dashboard.brushingMinutes",
            "PlaqueTracker.dashboard.perfectScanCount"
        ]
        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
        photoVM.resetDemoData()
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AppSettings.shared)
    }
}
#endif
