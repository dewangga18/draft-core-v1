import Foundation

/// Single responsibility: sign in.
struct SignInUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction(email: String, password: String) async throws -> User {
        try await repository.signIn(email: email, password: password)
    }
}
