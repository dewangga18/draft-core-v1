import SwiftUI

/// Architecture feature card.
struct InfoCard: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.12))
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(color)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.inter(15, weight: .semibold))

                Text(subtitle)
                    .font(.inter(13))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }
}
