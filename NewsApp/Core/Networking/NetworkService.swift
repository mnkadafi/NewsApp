//
//  NetworkService.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import Foundation

actor NetworkService {
    static let shared = NetworkService()
    private let apiKey = ""
    private let baseURL = "https://newsapi.org/v2"

    private init() {}

    @concurrent
    func fetch<T: Decodable>(_ type: T.Type, endpoint: String, queryItems: [URLQueryItem]) async throws -> T {
        var components = URLComponents(string: baseURL + endpoint)!
        components.queryItems = queryItems + [URLQueryItem(name: "apiKey", value: apiKey)]

        guard let url = components.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw NetworkError.apiError(apiError?.message ?? "Unknown server error (Status: \(httpResponse.statusCode))")
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

// Helper for API error decoding
nonisolated private struct APIErrorResponse: Decodable {
    let status: String
    let code: String?
    let message: String
}
