import Foundation

/// General (non-sensitive) storage protocol.
/// Backed by UserDefaults.
/// Use for: theme mode, notification flags, onboarding state.
protocol StorageRepository: Sendable {

    func setString(_ value: String, forKey key: String)
    func getString(forKey key: String) -> String?

    func setBool(_ value: Bool, forKey key: String)
    func getBool(forKey key: String) -> Bool?

    func setInt(_ value: Int, forKey key: String)
    func getInt(forKey key: String) -> Int?

    func remove(forKey key: String)
    func clearAll()
}
