import SwiftUI

/// BLoC equivalent for settings — persists via StorageRepository (UserDefaults).
@Observable
@MainActor
final class SettingsViewModel {

    // MARK: – State
    private(set) var colorScheme: ColorScheme? = nil     // nil = system
    private(set) var notificationsEnabled: Bool = true

    private let storage: StorageRepository

    init(storage: StorageRepository) {
        self.storage = storage
    }

    // MARK: – Events

    /// Load persisted settings — call on appear.
    func load() {
        let stored = storage.getString(forKey: AppStrings.Keys.themeMode)
        colorScheme = parseColorScheme(stored)
        notificationsEnabled = storage.getBool(forKey: AppStrings.Keys.pushNotifications) ?? true
    }

    /// Change and persist the app theme.
    func setTheme(_ scheme: ColorScheme?) {
        colorScheme = scheme
        let value: String
        switch scheme {
        case .light: value = "light"
        case .dark:  value = "dark"
        default:     value = "system"
        }
        storage.setString(value, forKey: AppStrings.Keys.themeMode)
        AppLogger.info("SettingsViewModel: theme → \(value)", category: .storage)
    }

    /// Toggle push notifications.
    func toggleNotifications(_ enabled: Bool) {
        notificationsEnabled = enabled
        storage.setBool(enabled, forKey: AppStrings.Keys.pushNotifications)
    }

    // MARK: – Helpers
    private func parseColorScheme(_ value: String?) -> ColorScheme? {
        switch value {
        case "light": return .light
        case "dark":  return .dark
        default:      return nil  // system
        }
    }

    /// For use in `.preferredColorScheme()` modifier.
    var preferredColorScheme: ColorScheme? { colorScheme }

    /// Display label for the current theme.
    var themeLabel: String {
        switch colorScheme {
        case .light: return AppStrings.themeLight
        case .dark:  return AppStrings.themeDark
        default:     return AppStrings.themeSystem
        }
    }
}
