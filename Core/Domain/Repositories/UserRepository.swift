import Foundation

/// User repository protocol.
protocol UserRepository: Sendable {
    func getUser(id: String) async throws -> User
    func updateUser(_ user: User) async throws -> User
    func deleteAccount(id: String) async throws
}
