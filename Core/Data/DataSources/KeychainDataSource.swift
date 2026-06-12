//
//  KeychainDataSource.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import Foundation
import Security

/// Concrete implementation of SecureStorageRepository.
/// Uses iOS Keychain Services.
final class KeychainDataSource: SecureStorageRepository {

    private let service: String

    init(service: String = Bundle.main.bundleIdentifier ?? "com.coretemplate") {
        self.service = service
    }

    // MARK: – Write
    func write(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw AppError.cache(message: "Keychain: cannot encode value for key \"\(key)\"")
        }

        // Delete existing before adding (update pattern)
        try? delete(key: key)

        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrService:      service,
            kSecAttrAccount:      key,
            kSecValueData:        data,
            kSecAttrAccessible:   kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw AppError.cache(message: "Keychain write failed (\(status)) for key \"\(key)\"")
        }
        AppLogger.debug("Keychain: wrote \"\(key)\"", category: .storage)
    }

    // MARK: – Read
    func read(key: String) throws -> String? {
        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrService:      service,
            kSecAttrAccount:      key,
            kSecReturnData:       true,
            kSecMatchLimit:       kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound { return nil }

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8)
        else {
            throw AppError.cache(message: "Keychain read failed (\(status)) for key \"\(key)\"")
        }
        return value
    }

    // MARK: – Delete
    func delete(key: String) throws {
        let query: [CFString: Any] = [
            kSecClass:        kSecClassGenericPassword,
            kSecAttrService:  service,
            kSecAttrAccount:  key,
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AppError.cache(message: "Keychain delete failed (\(status)) for key \"\(key)\"")
        }
        AppLogger.debug("Keychain: deleted \"\(key)\"", category: .storage)
    }

    // MARK: – Delete All
    func deleteAll() throws {
        let query: [CFString: Any] = [
            kSecClass:        kSecClassGenericPassword,
            kSecAttrService:  service,
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AppError.cache(message: "Keychain deleteAll failed (\(status))")
        }
        AppLogger.info("Keychain: deleted all items", category: .storage)
    }

    // MARK: – Contains Key
    func containsKey(_ key: String) throws -> Bool {
        try read(key: key) != nil
    }
}
