//
//  RegisterUseCase.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import Foundation

/// Single responsibility: register a new account.
struct RegisterUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction(fullName: String, email: String, password: String) async throws -> User {
        try await repository.register(fullName: fullName, email: email, password: password)
    }
}
