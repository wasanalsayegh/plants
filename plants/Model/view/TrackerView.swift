import SwiftUI

struct TrackerView: View {
    @EnvironmentObject var store: PlantStore
    @State private var showAdd = false
    @State private var plantToEdit: Plant?

    private var doneCount: Int { store.plants.filter { $0.isDone }.count }
    private var progress: Double {
        store.plants.isEmpty ? 0 : Double(doneCount) / Double(store.plants.count)
    }
    private var allDone: Bool {
        !store.plants.isEmpty && doneCount == store.plants.count
    }
    private var message: String {
        doneCount == 0
        ? "Your plants are waiting for a sip 💦"
        : "\(doneCount) of your plants feel loved today ✨"
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("My Plants 🌱")
                    .font(.title2.bold())
                    .padding(.horizontal)
                    .padding(.top, 8)

                if store.plants.isEmpty {
                    emptyState
                } else if allDone {
                    allDoneState
                } else {
                    VStack(spacing: 8) {
                        Text(message).font(.caption)
                        ProgressView(value: progress).tint(Color.plantGreen)
                    }
                    .padding()

                    plantList
                }
            }

            Button {
                showAdd = true
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.plantGreen)
                    .clipShape(Circle())
            }
            .padding(24)
        }
        .foregroundStyle(.white)
        .sheet(isPresented: $showAdd) {
            SetReminderView()
        }
        .sheet(item: $plantToEdit) { plant in
            SetReminderView(plantToEdit: plant)
        }
    }

    // MARK: - الحالات

    private var emptyState: some View {
        VStack {
            Spacer()
            Text("No reminders set yet..")
                .font(.caption)
                .foregroundStyle(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var allDoneState: some View {
        VStack(spacing: 8) {
            Spacer()
            Image("plant")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
            Text("All Done! 🎉")
                .font(.headline)
            Text("All Reminders Completed")
                .font(.caption2)
                .foregroundStyle(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var plantList: some View {
        List {
            ForEach(store.plants) { plant in
                HStack(alignment: .top, spacing: 12) {
                    Button {
                        withAnimation { store.toggle(plant) }
                    } label: {
                        Image(systemName: plant.isDone ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(plant.isDone ? Color.plantGreen : .gray)
                    }
                    .buttonStyle(.plain)

                    VStack(alignment: .leading, spacing: 4) {
                        Label("in \(plant.room)", systemImage: "location")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                        Text(plant.name)
                            .font(.headline)
                            .foregroundStyle(plant.isDone ? .gray : .white)
                        HStack(spacing: 6) {
                            chip(icon: "sun.max", text: plant.light)
                            chip(icon: "drop", text: plant.water)
                        }
                    }
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture { plantToEdit = plant }     // اضغط على النبتة = تعديل
                .listRowBackground(Color.black)
                .swipeActions(edge: .trailing) {          // اسحب لليسار = حذف
                    Button(role: .destructive) {
                        withAnimation { store.delete(plant) }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func chip(icon: String, text: String) -> some View {
        Label(text, systemImage: icon)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.white.opacity(0.1))
            .clipShape(Capsule())
    }
}

#Preview {
    TrackerView().environmentObject(PlantStore.sample)
}
