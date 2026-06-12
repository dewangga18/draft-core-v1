//
//  AuthRemoteDataSource.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import Foundation

/// Protocol for the auth remote data source.
/// Enables swapping the real HTTP implementation for a mock in tests.
protocol AuthRemoteDataSource: Sendable {
    func signIn(email: String, password: String) async throws -> AuthResponseModel
    func register(fullName: String, email: String, password: String) async throws -> AuthResponseModel
    func signOut(accessToken: String) async throws
    func refreshToken(_ refreshToken: String) async throws -> String
    func getProfile(accessToken: String) async throws -> UserModel
}

// MARK: – Concrete URLSession implementation
final class AuthRemoteDataSourceImpl: AuthRemoteDataSource {

    private let session: URLSession
    private let baseURL: URL

    init(session: URLSession, baseURL: URL) {
        self.session = session
        self.baseURL = baseURL
    }

    func signIn(email: String, password: String) async throws -> AuthResponseModel {
        let body = ["email": email, "password": password]
        return try await post(path: "/auth/sign-in", body: body, token: nil)
    }

    func register(fullName: String, email: String, password: String) async throws -> AuthResponseModel {
        let body = ["full_name": fullName, "email": email, "password": password]
        return try await post(path: "/auth/register", body: body, token: nil)
    }

    func signOut(accessToken: String) async throws {
        var request = urlRequest(path: "/auth/sign-out", method: "POST")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let (_, response) = try await session.data(for: request)
        try validate(response: response)
    }

    func refreshToken(_ refreshToken: String) async throws -> String {
        let body = ["refresh_token": refreshToken]
        let data = try await postRaw(path: "/auth/refresh", body: body, token: nil)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let token = json?["access_token"] as? String else {
            throw AppError.server(message: "Missing access_token in refresh response", statusCode: nil)
        }
        return token
    }

    func getProfile(accessToken: String) async throws -> UserModel {
        var request = urlRequest(path: "/auth/me", method: "GET")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await session.data(for: request)
        try validate(response: response)
        return try JSONDecoder.iso8601.decode(UserModel.self, from: data)
    }

    // MARK: – Helpers
    private func post<T: Decodable>(path: String, body: [String: String], token: String?) async throws -> T {
        let data = try await postRaw(path: path, body: body, token: token)
        return try JSONDecoder.iso8601.decode(T.self, from: data)
    }

    private func postRaw(path: String, body: [String: String], token: String?) async throws -> Data {
        var request = urlRequest(path: path, method: "POST")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        if let token { request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)
        return data
    }

    private func urlRequest(path: String, method: String) -> URLRequest {
        var req = URLRequest(url: baseURL.appending(path: path))
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        return req
    }

    private func validate(response: URLResponse, data: Data? = nil) throws {
        guard let http = response as? HTTPURLResponse else {
            throw AppError.network
        }
        guard (200..<300).contains(http.statusCode) else {
            let message = data.flatMap { try? JSONDecoder().decode([String: String].self, from: $0)["message"] } ?? ""
            throw AppError.from(statusCode: http.statusCode, message: message)
        }
    }
}

private extension JSONDecoder {
    static let iso8601: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
}
