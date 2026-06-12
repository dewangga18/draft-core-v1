//
//  ProfileView.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import SwiftUI

/// Profile screen.
struct ProfileView: View {

    private var authVM = DIContainer.shared.authViewModel
    private var navigationService = DIContainer.shared.navigationService

    var body: some View {
        List {
            // Avatar + name
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Circle()
                            .fill(AppTheme.primaryBlue)
                            .frame(width: 88, height: 88)
                            .overlay {
                                Text(authVM.user?.initials ?? "?")
                                    .font(.inter(36, weight: .bold))
                                    .foregroundStyle(.white)
                            }

                        VStack(spacing: 4) {
                            Text(authVM.user?.fullName ?? "—")
                                .font(.inter(20, weight: .bold))
                            Text(authVM.user?.email ?? "—")
                                .font(.inter(14))
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 16)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }

            Section("Details") {
                ProfileRow(label: "User ID",       value: authVM.user?.id ?? "—")
                ProfileRow(
                    label: "Member Since",
                    value: authVM.user.map { formattedDate($0.createdAt) } ?? "—"
                )
                ProfileRow(
                    label: "Sensitive Storage",
                    value: "Keychain (iOS Security framework)",
                    valueColor: AppTheme.primaryBlue
                )
                ProfileRow(
                    label: "General Storage",
                    value: "UserDefaults",
                    valueColor: AppTheme.successGreen
                )
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(AppStrings.profile)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navigationService.popMain()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}

private struct ProfileRow: View {
    let label: String
    let value: String
    var valueColor: Color? = nil

    var body: some View {
        HStack {
            Text(label)
                .font(.inter(15))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.inter(15, weight: .medium))
                .foregroundStyle(valueColor ?? .primary)
                .multilineTextAlignment(.trailing)
        }
    }
}
