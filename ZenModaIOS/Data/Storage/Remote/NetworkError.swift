//
//  NetworkError.swift
//  ZenModaIOS
//
//  Created by Shahruh on 16.06.2025.
//
import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case networkFailure(String)
    case unauthorized
    case forbidden
    case notFound
    case timeout
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .networkFailure(let message):
            return "Network failure: \(message)"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .timeout:
            return "Request timeout"
        case .unknown:
            return "Unknown error occurred"
        }
    }
    
    var userFriendlyMessage: String {
        switch self {
        case .invalidURL, .unknown:
            return "Something went wrong. Please try again."
        case .noData, .decodingError:
            return "Unable to process the response. Please try again."
        case .serverError(let code):
            return code >= 500 ? "Server is temporarily unavailable. Please try again later." : "Something went wrong. Please try again."
        case .networkFailure:
            return "Network connection failed. Please check your internet connection."
        case .unauthorized:
            return "Please log in again."
        case .forbidden:
            return "You don't have permission to access this resource."
        case .notFound:
            return "The requested resource was not found."
        case .timeout:
            return "Request timed out. Please try again."
        }
    }
}
