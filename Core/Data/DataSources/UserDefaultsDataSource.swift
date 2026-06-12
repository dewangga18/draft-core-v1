import Foundation

/// Concrete implementation of StorageRepository.
/// Uses UserDefaults for non-sensitive data: theme, flags, preferences.
final class UserDefaultsDataSource: StorageRepository {

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func setString(_ value: String, forKey key: String) {
        defaults.set(value, forKey: key)
        AppLogger.debug("UserDefaults: set string for \"\(key)\"", category: .storage)
    }

    func getString(forKey key: String) -> String? {
        defaults.string(forKey: key)
    }

    func setBool(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func getBool(forKey key: String) -> Bool? {
        defaults.object(forKey: key) != nil ? defaults.bool(forKey: key) : nil
    }

    func setInt(_ value: Int, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func getInt(forKey key: String) -> Int? {
        defaults.object(forKey: key) != nil ? defaults.integer(forKey: key) : nil
    }

    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    func clearAll() {
        guard let domain = Bundle.main.bundleIdentifier else { return }
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        AppLogger.info("UserDefaults: cleared all values", category: .storage)
    }
}
