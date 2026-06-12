import SwiftUI

/// Reusable text field with icon, secure toggle, and inline error.
struct AppTextField: View {
    @Binding var text: String
    let label: String
    var systemImage: String     = "textformat"
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool          = false
    var trailingIcon: String?   = nil
    var onTrailingTap: (() -> Void)? = nil
    var errorMessage: String?   = nil

    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(focused ? AppTheme.primaryBlue : .secondary)
                    .frame(width: 20)

                Group { () -> AnyView in
                    if isSecure {
                        return AnyView(SecureField(label, text: $text))
                    } else {
                        return AnyView(
                            TextField(label, text: $text)
                                .keyboardType(keyboardType)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .words)
                        )
                    }
                }
                .font(.inter(16))
                .focused($focused)

                if let icon = trailingIcon {
                    Button {
                        onTrailingTap?()
                    } label: {
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                errorMessage != nil ? AppTheme.errorRed :
                                    focused ? AppTheme.primaryBlue : Color.clear,
                                lineWidth: 1.5
                            )
                    }
            }
            .animation(.easeInOut(duration: 0.15), value: focused)

            if let error = errorMessage {
                Text(error)
                    .font(.inter(13))
                    .foregroundStyle(AppTheme.errorRed)
                    .padding(.leading, 4)
            }
        }
    }
}
