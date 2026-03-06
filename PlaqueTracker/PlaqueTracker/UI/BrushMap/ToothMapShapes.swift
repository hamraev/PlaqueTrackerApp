import SwiftUI

struct ToothMapView: View {
    typealias Zone = BrushMapViewModel.Zone

    let intensity: [Zone: Double]
    let selectedZone: Zone?
    let onSelect: (Zone) -> Void

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Background card
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(.white.opacity(0.15), lineWidth: 1)
                    )

                VStack(spacing: 18) {
                    jawRow(title: "Upper Teeth", isUpper: true, width: w * 0.92, height: h * 0.36)
                    jawRow(title: "Lower Teeth", isUpper: false, width: w * 0.92, height: h * 0.36)
                }
                .padding(18)
            }
        }
    }

    private func jawRow(title: String, isUpper: Bool, width: CGFloat, height: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)

            ZStack {
                JawShape(isUpper: isUpper)
                    .fill(Color.white.opacity(0.12))

                JawShape(isUpper: isUpper)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)

                // Zones overlay: left/right halves
                HStack(spacing: 10) {
                    zoneButton(zone: isUpper ? .upperLeft : .lowerLeft, isUpper: isUpper)
                    zoneButton(zone: isUpper ? .upperRight : .lowerRight, isUpper: isUpper)
                }
                .padding(12)
            }
            .frame(width: width, height: height)
        }
    }

    private func zoneButton(zone: Zone, isUpper: Bool) -> some View {
        let level = intensity[zone] ?? 0.2
        let isSelected = selectedZone == zone

        return Button {
            onSelect(zone)
        } label: {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(isSelected ? Color.white.opacity(0.65) : Color.white.opacity(0.12), lineWidth: isSelected ? 2 : 1)
                )
                .overlay(glow(level: level, selected: isSelected))
        }
        .buttonStyle(.plain)
    }

    private func glow(level: Double, selected: Bool) -> some View {
        // Glow becomes stronger with intensity. Selected gets an extra boost.
        let base = 0.15 + level * 0.55 + (selected ? 0.15 : 0.0)

        return RoundedRectangle(cornerRadius: 18)
            .fill(Color.white.opacity(base))
            .blur(radius: 10)
            .opacity(0.9)
            .animation(.easeInOut(duration: 0.6), value: level)
    }
}

struct JawShape: Shape {
    let isUpper: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()

        // Simple stylized jaw curve (good enough for MVP)
        let inset: CGFloat = rect.width * 0.06
        let r = rect.insetBy(dx: inset, dy: rect.height * 0.12)

        let topY = r.minY
        let bottomY = r.maxY

        if isUpper {
            p.move(to: CGPoint(x: r.minX, y: bottomY))
            p.addQuadCurve(to: CGPoint(x: r.midX, y: topY), control: CGPoint(x: r.minX, y: topY))
            p.addQuadCurve(to: CGPoint(x: r.maxX, y: bottomY), control: CGPoint(x: r.maxX, y: topY))
            p.addQuadCurve(to: CGPoint(x: r.minX, y: bottomY), control: CGPoint(x: r.midX, y: bottomY + r.height * 0.35))
        } else {
            p.move(to: CGPoint(x: r.minX, y: topY))
            p.addQuadCurve(to: CGPoint(x: r.midX, y: bottomY), control: CGPoint(x: r.minX, y: bottomY))
            p.addQuadCurve(to: CGPoint(x: r.maxX, y: topY), control: CGPoint(x: r.maxX, y: bottomY))
            p.addQuadCurve(to: CGPoint(x: r.minX, y: topY), control: CGPoint(x: r.midX, y: topY - r.height * 0.35))
        }

        p.closeSubpath()
        return p
    }
}
