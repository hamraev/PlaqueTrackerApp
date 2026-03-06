import SwiftUI

struct DashboardView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard
                statsRow
                startScanButton
            }
            .padding()
        }
        .navigationTitle("PlaqueTracker")
    }
}

private extension DashboardView {
    var headerCard: some View {
        VStack(spacing: 12) {
            Text("Great job today!")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("Your smile looks good. Let’s do a quick scan to check for missed spots.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 140, height: 140)

                VStack(spacing: 4) {
                    Text("82")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                    Text("Smile Score")
                        .font(.headline)
                }
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.green.opacity(0.12))
        )
    }

    var statsRow: some View {
        HStack(spacing: 12) {
            statCard(title: "Streak", value: "5 days", icon: "flame.fill")
            statCard(title: "XP", value: "120", icon: "star.fill")
        }
    }

    func statCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)

            Text(value)
                .font(.title3.bold())

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.10))
        )
    }

    var startScanButton: some View {
        Button {
            // Next step: hook this into scan flow
        } label: {
            HStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                Text("Start Scan")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
