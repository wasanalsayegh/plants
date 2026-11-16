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

    private let fieldBackground = Color(white: 0.17)

    private var isEditing: Bool { plantToEdit != nil }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // Plant Name
                    HStack(spacing: 8) {
                        Text("Plant Name")
                        TextField("Pothos", text: $name)
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 60)
                    .background(fieldBackground, in: Capsule())

                    // Room + Light
                    VStack(spacing: 0) {
                        row(icon: "location", title: "Room", selection: $room,
                            options: ["Bedroom", "Living Room", "Kitchen", "Balcony","Bathroom"])
                        Divider().padding(.leading, 40)
                        row(icon: "sun.max", title: "Light", selection: $light,
                            options: ["Full sun", "Partial sun", "Low light"])
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(fieldBackground, in: RoundedRectangle(cornerRadius: 30))

                    // Watering
                    VStack(spacing: 0) {
                        row(icon: "drop", title: "Watering Days", selection: $days,
                            options: ["Every day", "Every 2 days", "Every week"])
                        Divider().padding(.leading, 40)
                        row(icon: "drop", title: "Water", selection: $water,
                            options: ["20-50 ml", "50-100 ml", "100-200 ml"])
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(fieldBackground, in: RoundedRectangle(cornerRadius: 30))

                    // Delete
                    if let plant = plantToEdit {
                        Button(role: .destructive) {
                            store.delete(plant)
                            dismiss()
                        } label: {
                            Text("Delete Reminder")
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(fieldBackground, in: Capsule())
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
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
                    name = p.name
                    room = p.room
                    light = p.light
                    days = p.days
                    water = p.water
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // One row: white icon + title + picker
    private func row(icon: String, title: String,
                     selection: Binding<String>, options: [String]) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .frame(width: 24)
            Text(title)
            Spacer()
            Picker("", selection: selection) {
                ForEach(options, id: \.self) { Text($0) }
            }
            .pickerStyle(.menu)
            .tint(.secondary)
        }
        .frame(height: 48)
    }

    private func save() {
        if var p = plantToEdit {
            p.name = name
            p.room = room
            p.light = light
            p.days = days
            p.water = water
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
