import SwiftUI

@main
struct MyApp: App {
    @StateObject private var store = PlantStore()
    @AppStorage("hasStarted") private var hasStarted = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasStarted {
                    TrackerView()
                } else {
                    StartView()
                }
            }
            .environmentObject(store)
            .preferredColorScheme(.dark)
        }
    }
}
