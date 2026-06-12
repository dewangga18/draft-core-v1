import Foundation

/// Auth response from server.
struct AuthResponseModel: Decodable {
    let accessToken: String
    let refreshToken: String
    let user: UserModel

    enum CodingKeys: String, CodingKey {
        case accessToken  = "access_token"
        case refreshToken = "refresh_token"
        case user
    }
}
