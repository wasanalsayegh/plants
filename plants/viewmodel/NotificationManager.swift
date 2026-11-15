import UserNotifications

enum NotificationManager {
    
    static let testMode = true

    static func schedule(for plant: Plant) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }

            center.removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])

            let content = UNMutableNotificationContent()
            content.title = "Planto"
            content.body = "Hey! let's water your plant 🌱"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: testMode ? 5 : interval(for: plant.days),
                repeats: !testMode
            )
            let request = UNNotificationRequest(identifier: plant.id.uuidString,
                                                content: content,
                                                trigger: trigger)
            center.add(request)
        }
    }

    static func cancel(for plant: Plant) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])
    }

    private static func interval(for days: String) -> TimeInterval {
        switch days {
        case "Every 2 days": return 2 * 86_400
        case "Every week":   return 7 * 86_400
        default:             return 86_400
        }
    }
}
