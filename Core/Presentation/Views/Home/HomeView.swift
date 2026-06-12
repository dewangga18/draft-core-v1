import SwiftUI

/// Home screen.
struct HomeView: View {

    private var authVM = DIContainer.shared.authViewModel
    private var navState = DIContainer.shared.navState
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        List {
            // Greeting
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello, \(authVM.user?.firstName ?? "there")")
                        .font(.inter(26, weight: .bold))
                    Text("Welcome to the core template.")
                        .font(.inter(15))
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }

            // Architecture overview
            Section("Architecture Overview") {
                InfoCard(
                    icon: "lock.shield",
                    color: AppTheme.primaryBlue,
                    title: "Keychain Storage",
                    subtitle: "Tokens & passwords via iOS Keychain (Security framework)"
                )
                InfoCard(
                    icon: "externaldrive",
                    color: AppTheme.successGreen,
                    title: "UserDefaults Storage",
                    subtitle: "Preferences & flags via UserDefaults (non-sensitive)"
                )
                InfoCard(
                    icon: "arrow.triangle.2.circlepath",
                    color: AppTheme.accentIndigo,
                    title: "ViewModel (BLoC equivalent)",
                    subtitle: "@Observable ViewModels — events become async methods, state becomes properties"
                )
                InfoCard(
                    icon: "square.3.layers.3d",
                    color: AppTheme.warningOrange,
                    title: "Clean Architecture",
                    subtitle: "Domain protocols → Data implementations → Presentation ViewModels"
                )
            }

            // Navigate
            Section("Navigate") {
                Button {
                    navState.mainOwl.push(.profile)
                } label: {
                    HStack {
                        SectionTile(icon: "person", label: AppStrings.profile)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                }
                Button {
                    navState.mainOwl.push(.settings)
                } label: {
                    HStack {
                        SectionTile(icon: "gear", label: AppStrings.settings)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // Sign out
            Section {
                Button(role: .destructive) {
                    Task { await authVM.performSignOut() }
                } label: {
                    SectionTile(
                        icon: "rectangle.portrait.and.arrow.right",
                        label: AppStrings.logout,
                        color: AppTheme.errorRed
                    )
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(AppStrings.appName)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    navState.mainOwl.push(.profile)
                } label: {
                    Image(systemName: "person.circle")
                        .font(.system(size: 18))
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    navState.mainOwl.push(.settings)
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 18))
                }
            }
        }
    }
}
