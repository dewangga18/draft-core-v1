import SwiftUI

/// Reusable primary button.
struct AppButton: View {
    let title: String
    let isLoading: Bool
    var isDestructive: Bool = false
    var isOutlined: Bool    = false
    var color: Color        = AppTheme.primaryBlue
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.inter(16, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .foregroundStyle(isOutlined ? color : .white)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isOutlined ? Color.clear : (isDestructive ? AppTheme.errorRed : color))
                    .overlay {
                        if isOutlined {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(color, lineWidth: 1.5)
                        }
                    }
            }
        }
        .disabled(isLoading)
        .animation(.easeInOut(duration: 0.15), value: isLoading)
    }
}
