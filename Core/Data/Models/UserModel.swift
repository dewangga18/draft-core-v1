//
//  UserModel.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import Foundation

/// Data model — knows how to decode/encode JSON.
/// Maps snake_case JSON to Swift camelCase automatically via CodingKeys.
struct UserModel: Codable {
    let id: String
    let fullName: String
    let email: String
    let avatarURL: URL?
    let createdAt: Date
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName  = "full_name"
        case email
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    /// Convert to domain entity — data layer should never leak into domain.
    func toDomain() -> User {
        User(
            id:        id,
            fullName:  fullName,
            email:     email,
            avatarURL: avatarURL,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    /// Convert from domain entity (for cache writes).
    init(from user: User) {
        self.id        = user.id
        self.fullName  = user.fullName
        self.email     = user.email
        self.avatarURL = user.avatarURL
        self.createdAt = user.createdAt
        self.updatedAt = user.updatedAt
    }
}
