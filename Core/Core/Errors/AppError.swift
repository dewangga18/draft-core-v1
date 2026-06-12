//
//  AppError.swift
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import Foundation

/// Typed error hierarchy.
enum AppError: LocalizedError, Equatable {

    case network
    case unauthorized
    case notFound
    case server(message: String, statusCode: Int?)
    case cache(message: String)
    case validation(message: String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .network:
            return AppStrings.errorNetwork
        case .unauthorized:
            return AppStrings.errorUnauthorized
        case .notFound:
            return AppStrings.errorNotFound
        case .server(let message, _):
            return message
        case .cache(let message):
            return message
        case .validation(let message):
            return message
        case .unknown:
            return AppStrings.errorGeneric
        }
    }

    var statusCode: Int? {
        switch self {
        case .unauthorized:          return 401
        case .notFound:              return 404
        case .server(_, let code):   return code
        default:                     return nil
        }
    }

    // MARK: – Conversion from URLResponse
    static func from(statusCode: Int, message: String = "") -> AppError {
        switch statusCode {
        case 401: return .unauthorized
        case 404: return .notFound
        default:  return .server(message: message.isEmpty ? AppStrings.errorServerError : message,
                                 statusCode: statusCode)
        }
    }
}
