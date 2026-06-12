//
//  GetCurrentUserUseCase.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

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
