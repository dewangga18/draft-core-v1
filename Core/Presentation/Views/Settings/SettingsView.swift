//
//  SettingsView.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import SwiftUI

/// Settings screen.
struct SettingsView: View {

    private var settingsVM = DIContainer.shared.settingsViewModel
    private var navState = DIContainer.shared.navState

    var body: some View {
        List {
            // ── Appearance ──────────────────────────────────────────────────
            Section(AppStrings.appearance) {
                Picker("Theme", selection: Binding(
                    get: { settingsVM.colorScheme },
                    set: { settingsVM.setTheme($0) }
                )) {
                    Text(AppStrings.themeSystem).tag(ColorScheme?.none)
                    Text(AppStrings.themeLight).tag(ColorScheme?.some(.light))
                    Text(AppStrings.themeDark).tag(ColorScheme?.some(.dark))
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 4)
            }

            // ── Notifications ────────────────────────────────────────────────
            Section(AppStrings.notifications) {
                Toggle(isOn: Binding(
                    get: { settingsVM.notificationsEnabled },
                    set: { settingsVM.toggleNotifications($0) }
                )) {
                    Label(AppStrings.notifications, systemImage: "bell")
                }
                .tint(AppTheme.primaryBlue)
            }

            // ── Storage info ─────────────────────────────────────────────────
            Section(AppStrings.security) {
                StorageInfoRow(
                    icon: "lock.shield",
                    color: AppTheme.primaryBlue,
                    title: "Sensitive Data",
                    subtitle: "Keychain (iOS Security framework)"
                )
                StorageInfoRow(
                    icon: "externaldrive",
                    color: AppTheme.successGreen,
                    title: "Preferences",
                    subtitle: "UserDefaults (non-sensitive)"
                )
            }

            // ── About ────────────────────────────────────────────────────────
            Section(AppStrings.about) {
                HStack {
                    Label(AppStrings.version, systemImage: "info.circle")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(AppStrings.appVersion)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(AppStrings.settings)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navState.mainOwl.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
        .onAppear { settingsVM.load() }
    }
}

private struct StorageInfoRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.inter(15))
                Text(subtitle)
                    .font(.inter(13))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
