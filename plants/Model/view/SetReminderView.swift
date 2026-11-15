import SwiftUI

struct SetReminderView: View {
    @EnvironmentObject var store: PlantStore
    @Environment(\.dismiss) private var dismiss

    var plantToEdit: Plant? = nil

    @State private var name = ""
    @State private var room = "Bedroom"
    @State private var light = "Full sun"
    @State private var days = "Every day"
    @State private var water = "20-50 ml"

    private var isEditing: Bool { plantToEdit != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Plant Name")
                        TextField("Pothos", text: $name)
                    }
                }

                Section {
                    Picker("Room", selection: $room) {
                        ForEach(["Bedroom", "Living Room", "Kitchen", "Balcony"], id: \.self) { Text($0) }
                    }
                    Picker("Light", selection: $light) {
                        ForEach(["Full sun", "Partial sun", "Low light"], id: \.self) { Text($0) }
                    }
                }

                Section {
                    Picker("Watering Days", selection: $days) {
                        ForEach(["Every day", "Every 2 days", "Every week"], id: \.self) { Text($0) }
                    }
                    Picker("Water", selection: $water) {
                        ForEach(["20-50 ml", "50-100 ml", "100-200 ml"], id: \.self) { Text($0) }
                    }
                }

                if let plant = plantToEdit {
                    Section {
                        Button(role: .destructive) {
                            store.delete(plant)
                            dismiss()
                        } label: {
                            Text("Delete Reminder")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(white: 0.11))
            .navigationTitle(isEditing ? "Edit Reminder" : "Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: { Image(systemName: "xmark") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { save() } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(Color.plantGreen)
                            .clipShape(Circle())
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let p = plantToEdit {
                    name = p.name; room = p.room; light = p.light
                    days = p.days; water = p.water
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func save() {
        if var p = plantToEdit {
            p.name = name; p.room = room; p.light = light
            p.days = days; p.water = water
            store.update(p)
        } else {
            store.add(Plant(name: name, room: room, light: light, days: days, water: water))
        }
        dismiss()
    }
}

#Preview {
    SetReminderView().environmentObject(PlantStore())
}
