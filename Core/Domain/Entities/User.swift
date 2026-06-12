//
//  User.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import Foundation

/// Domain entity — pure Swift, zero framework dependencies.
struct User: Equatable, Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    let avatarURL: URL?
    let createdAt: Date
    let updatedAt: Date?

    init(
        id: String,
        fullName: String,
        email: String,
        avatarURL: URL? = nil,
        createdAt: Date,
        updatedAt: Date? = nil
    ) {
        self.id        = id
        self.fullName  = fullName
        self.email     = email
        self.avatarURL = avatarURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    func copyWith(
        id: String?       = nil,
        fullName: String? = nil,
        email: String?    = nil,
        avatarURL: URL??  = nil,
        updatedAt: Date?? = nil
    ) -> User {
        User(
            id:        id ?? self.id,
            fullName:  fullName ?? self.fullName,
            email:     email ?? self.email,
            avatarURL: avatarURL ?? self.avatarURL,
            createdAt: createdAt,
            updatedAt: updatedAt ?? self.updatedAt
        )
    }

    /// First name for greetings.
    var firstName: String { fullName.components(separatedBy: " ").first ?? fullName }

    /// Initials for avatar placeholder.
    var initials: String {
        let parts = fullName.components(separatedBy: " ")
        let first = parts.first?.first.map(String.init) ?? ""
        let last  = parts.dropFirst().first?.first.map(String.init) ?? ""
        return (first + last).uppercased()
    }
}
