//
//  SecureStorageRepository.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import Foundation

/// Secure (sensitive) storage protocol.
/// Conforming types use iOS Keychain, Android Keystore, etc.
/// Use for: tokens, passwords, PINs, biometric keys.
protocol SecureStorageRepository: Sendable {

    /// Write a sensitive value to Keychain.
    func write(key: String, value: String) throws

    /// Read a sensitive value. Returns nil if the key does not exist.
    func read(key: String) throws -> String?

    /// Delete a sensitive value.
    func delete(key: String) throws

    /// Delete ALL values (e.g. on logout).
    func deleteAll() throws

    /// Whether a key exists in Keychain.
    func containsKey(_ key: String) throws -> Bool
}
