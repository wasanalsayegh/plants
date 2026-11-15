import SwiftUI
import SwiftUI
import Combine

extension Color {
    static let plantGreen = Color(red: 0.24, green: 0.55, blue: 0.45)
}

struct Plant: Identifiable {
    var id = UUID()
    var name: String
    var room: String = "Bedroom"
    var light: String = "Full sun"
    var days: String = "Every day"
    var water: String = "20-50 ml"
    var isDone: Bool = false
}

final class PlantStore: ObservableObject {
    @Published var plants: [Plant] = []

    func add(_ plant: Plant) {
        plants.append(plant)
        NotificationManager.schedule(for: plant)
    }

    func update(_ plant: Plant) {
        guard let i = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[i] = plant
        NotificationManager.schedule(for: plant)
    }

    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        NotificationManager.cancel(for: plant)
    }

    func toggle(_ plant: Plant) {
        guard let i = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[i].isDone.toggle()
    }

    static var sample: PlantStore {
        let s = PlantStore()
        s.plants = [
            Plant(name: "Monstera", room: "Kitchen"),
            Plant(name: "Pothos", room: "Bedroom"),
            Plant(name: "Orchid", room: "Living Room"),
            Plant(name: "Spider", room: "Kitchen")
        ]
        return s
    }
}
