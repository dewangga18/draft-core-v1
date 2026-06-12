import SwiftUI

/// Shown while auth status resolves.
struct SplashView: View {
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 24) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppTheme.primaryBlue)
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "square.3.layers.3d")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundStyle(.white)
                    }

                Text(AppStrings.appName)
                    .font(.inter(24, weight: .bold))

                ProgressView()
                    .controlSize(.regular)
                    .padding(.top, 16)
            }
        }
    }
}
