import Foundation

/// Auth repository protocol.
/// Every implementation (real, mock, stub) must conform to this.
protocol AuthRepository: Sendable {

    /// Sign in with email and password.
    func signIn(email: String, password: String) async throws -> User

    /// Register a new user account.
    func register(fullName: String, email: String, password: String) async throws -> User

    /// Sign the current user out and clear all tokens.
    func signOut() async throws

    /// Refresh the access token using the stored refresh token.
    @discardableResult
    func refreshToken() async throws -> String

    /// Returns the currently authenticated user, or nil if not logged in.
    func getCurrentUser() async throws -> User?

    /// Check if a session token exists in Keychain.
    func isAuthenticated() async -> Bool
}
