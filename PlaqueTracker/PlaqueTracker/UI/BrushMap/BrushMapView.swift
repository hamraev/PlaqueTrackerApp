import SwiftUI
import Combine

struct BrushMapView: View {
    @ObservedObject var dashboardVM: AppDashboardViewModel
    @StateObject private var vm = BrushMapViewModel()

    @State private var selectedZone: BrushMapViewModel.Zone? = nil

    var body: some View {
        VStack(spacing: 16) {
            header

            ToothMapView(
                intensity: vm.zoneIntensity,
                selectedZone: selectedZone,
                onSelect: { zone in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedZone = zone
                    }
                }
            )
            .frame(height: 320)
            .padding(.horizontal, 16)

            tipCard

            Spacer(minLength: 0)
        }
        .padding(.top, 12)
        .navigationTitle("Brush Map")
        .onAppear {
            vm.bind(plaqueScorePublisher: dashboardVM.plaqueScorePublisher)
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Text("Let’s check your brushing")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)

            Text("Tap a zone to see what to brush next.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
    }

    private var tipCard: some View {
        let zone = selectedZone

        return VStack(alignment: .leading, spacing: 8) {
            Text(zone?.title ?? "Pick a zone")
                .font(.system(size: 18, weight: .semibold))

            Text(tipText(for: zone))
                .font(.system(size: 15))
                .foregroundStyle(.secondary)

            HStack {
                Button("Start 15s") {
                    // later: start a mini timer + haptics
                }
                .buttonStyle(.borderedProminent)

                Button("Clear") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedZone = nil
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal, 16)
    }

    private func tipText(for zone: BrushMapViewModel.Zone?) -> String {
        guard let zone else {
            return "Try the glowing areas first. Small circles, gentle pressure."
        }

        switch zone {
        case .upperLeft:
            return "Brush the back teeth and along the gumline. Small circles for 15 seconds."
        case .upperRight:
            return "Go slowly near the gumline. Aim for tiny circles, then sweep down."
        case .lowerLeft:
            return "Lower back teeth love to hide plaque. Brush the inside surfaces too."
        case .lowerRight:
            return "Focus on the chewing surfaces and the gumline. Keep it gentle and steady."
        }
    }
}
