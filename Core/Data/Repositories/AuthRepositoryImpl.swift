import Foundation

/// Concrete implementation of AuthRepository.
/// Orchestrates remote HTTP calls with local Keychain storage.
final class AuthRepositoryImpl: AuthRepository {

    private let remote: AuthRemoteDataSource
    private let secureStorage: SecureStorageRepository

    init(remote: AuthRemoteDataSource, secureStorage: SecureStorageRepository) {
        self.remote        = remote
        self.secureStorage = secureStorage
    }

    // MARK: – Sign In
    func signIn(email: String, password: String) async throws -> User {
        do {
            let response = try await remote.signIn(email: email, password: password)
            try saveTokens(access: response.accessToken, refresh: response.refreshToken)
            try secureStorage.write(key: AppStrings.Keys.userId, value: response.user.id)
            AppLogger.info("User signed in: \(response.user.email)", category: .auth)
            return response.user.toDomain()
        } catch let error as AppError {
            AppLogger.warning("signIn error: \(error.localizedDescription ?? "")", category: .auth)
            throw error
        } catch {
            AppLogger.error("signIn unexpected", error: error, category: .auth)
            throw AppError.unknown
        }
    }

    // MARK: – Register
    func register(fullName: String, email: String, password: String) async throws -> User {
        do {
            let response = try await remote.register(fullName: fullName, email: email, password: password)
            try saveTokens(access: response.accessToken, refresh: response.refreshToken)
            try secureStorage.write(key: AppStrings.Keys.userId, value: response.user.id)
            AppLogger.info("User registered: \(response.user.email)", category: .auth)
            return response.user.toDomain()
        } catch let error as AppError {
            throw error
        } catch {
            throw AppError.unknown
        }
    }

    // MARK: – Sign Out
    func signOut() async throws {
        do {
            if let token = try? secureStorage.read(key: AppStrings.Keys.accessToken) {
                try await remote.signOut(accessToken: token)
            }
        } catch {
            // Best-effort sign-out: always clear local tokens
            AppLogger.warning("signOut remote call failed (ignored)", category: .auth)
        }
        try secureStorage.deleteAll()
        AppLogger.info("User signed out — Keychain cleared", category: .auth)
    }

    // MARK: – Refresh Token
    @discardableResult
    func refreshToken() async throws -> String {
        guard let stored = try secureStorage.read(key: AppStrings.Keys.refreshToken) else {
            throw AppError.unauthorized
        }
        let newToken = try await remote.refreshToken(stored)
        try secureStorage.write(key: AppStrings.Keys.accessToken, value: newToken)
        return newToken
    }

    // MARK: – Get Current User
    func getCurrentUser() async throws -> User? {
        guard let token = try? secureStorage.read(key: AppStrings.Keys.accessToken),
              !token.isEmpty else {
            return nil
        }
        do {
            let model = try await remote.getProfile(accessToken: token)
            return model.toDomain()
        } catch AppError.unauthorized {
            try? secureStorage.deleteAll()
            throw AppError.unauthorized
        }
    }

    // MARK: – Is Authenticated
    func isAuthenticated() async -> Bool {
        (try? secureStorage.containsKey(AppStrings.Keys.accessToken)) ?? false
    }

    // MARK: – Private helpers
    private func saveTokens(access: String, refresh: String) throws {
        try secureStorage.write(key: AppStrings.Keys.accessToken,  value: access)
        try secureStorage.write(key: AppStrings.Keys.refreshToken, value: refresh)
    }
}
