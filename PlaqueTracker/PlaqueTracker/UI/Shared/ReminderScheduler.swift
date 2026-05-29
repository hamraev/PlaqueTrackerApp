//
//  ReminderScheduler.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import Foundation
import Combine
import UserNotifications

final class ReminderScheduler: ObservableObject {
    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @Published var permissionMessage: String?

    private let reminderID = "PlaqueTracker.dailySmileMission"

    init() {
        refreshStatus()
    }

    func refreshStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.authorizationStatus = settings.authorizationStatus
                self?.permissionMessage = settings.authorizationStatus == .denied ? "Reminders are off in Settings. You can still use PlaqueTracker anytime." : nil
            }
        }
    }

    func requestAndSchedule(at date: Date) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            DispatchQueue.main.async {
                if granted {
                    self?.permissionMessage = nil
                    self?.scheduleDailyReminder(at: date)
                } else {
                    self?.permissionMessage = "Reminders are off. No problem, your smile mission is still ready here."
                }
                self?.refreshStatus()
            }
        }
    }

    func scheduleDailyReminder(at date: Date) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderID])

        let content = UNMutableNotificationContent()
        content.title = "Time for your smile mission!"
        content.body = "Don’t forget to brush the red spots!"
        content.sound = .default

        let time = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        let request = UNNotificationRequest(identifier: reminderID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func cancelReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderID])
    }
}
