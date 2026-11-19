//
//  NetworkError.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import Foundation

nonisolated enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case apiError(String)
    case noInternet

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The request URL was invalid."
        case .invalidResponse: return "The server returned an invalid response."
        case .decodingError(let error): return "Failed to decode data: \(error.localizedDescription)"
        case .apiError(let message): return "API Error: \(message)"
        case .noInternet: return "No internet connection. Please check your network."
        }
    }
}
