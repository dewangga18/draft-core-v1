import Foundation

/// Single responsibility: sign out.
struct SignOutUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws {
        try await repository.signOut()
    }
}
