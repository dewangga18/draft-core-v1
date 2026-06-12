import Foundation

/// Single responsibility: get the currently authenticated user.
struct GetCurrentUserUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> User? {
        try await repository.getCurrentUser()
    }
}
