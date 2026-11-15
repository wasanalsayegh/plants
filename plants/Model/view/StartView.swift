import SwiftUI

struct StartView: View {
    @EnvironmentObject var store: PlantStore
    @AppStorage("hasStarted") private var hasStarted = false
    @State private var showSetReminder = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("My Plants 🌱")
                        .font(.title2.bold())
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer()

                Image("plant")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)

                Text("Start your plant journey!")
                    .font(.headline)
                    .padding(.top, 24)

                Text("Now all your plants will be in one place and\nwe will help you take care of them :) 🪴")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                    .padding(.top, 6)

                Spacer()

                Button {
                    showSetReminder = true
                } label: {
                    Text("Set Plant Reminder")
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.plantGreen)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
            .foregroundStyle(.white)
        }
        .sheet(isPresented: $showSetReminder, onDismiss: {
            // إذا انحفظت نبتة، ننتقل لصفحة التراكر
            if !store.plants.isEmpty { hasStarted = true }
        }) {
            SetReminderView()
        }
    }
}

#Preview {
    StartView().environmentObject(PlantStore())
}
