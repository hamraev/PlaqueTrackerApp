import SwiftUI
import UIKit

struct WelcomeGateView: View {
    let onEnter: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.25), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Welcome to PlaqueTracker")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Group {
                    if UIImage(named: "WelcomeFront") != nil {
                        Image("WelcomeFront")
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.secondary)
                            .padding(40)
                    }
                }
                .frame(maxWidth: 320, maxHeight: 320)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.8))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)

                Button(action: onEnter) {
                    Label("Enter App", systemImage: "arrow.right.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 24)
        }
    }
}

#Preview {
    WelcomeGateView(onEnter: {})
}
