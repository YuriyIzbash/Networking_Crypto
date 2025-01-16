//
//  CoinAPIError.swift
//  Networking_Crypto
//
//  Created by YURIY IZBASH on 12. 1. 25.
//

import Foundation

enum CoinAPIError: Error {
    case invalidData
    case jsonParsingFailure
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidData:
            return "Invalid data"
        case .jsonParsingFailure:
            return "JSON parsing failure"
        case let .requestFailed(description):
            return "Request failed \(description)"
        case let .invalidStatusCode(statusCode):
            return "Invalid status code: \(statusCode)"
        case let .unknownError(error): return "An unknown error occurred \(error.localizedDescription)"
        }
    }
}
