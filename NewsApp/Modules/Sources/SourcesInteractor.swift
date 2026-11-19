//
//  SourcesInteractor.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import Foundation

final class SourcesInteractor: SourcesInteractorProtocol {
    weak var output: SourcesInteractorOutputProtocol?

    @concurrent
    func fetchSources(category: NewsCategory, page: Int, pageSize: Int, searchQuery: String?) async {
        do {
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "category", value: category.rawValue)
            ]

            let response = try await NetworkService.shared.fetch(
                SourcesResponse.self,
                endpoint: "/top-headlines/sources",
                queryItems: queryItems
            )

            let trimmedQuery = searchQuery?.trimmingCharacters(in: .whitespaces) ?? ""
            let filtered: [NewsSource] = trimmedQuery.isEmpty ? response.sources : response.sources.filter {
                $0.name.localizedCaseInsensitiveContains(trimmedQuery) ||
                ($0.description?.localizedCaseInsensitiveContains(trimmedQuery) ?? false)
            }
            
            if Task.isCancelled { return }

            await MainActor.run {
                output?.didFetchSources(filtered, totalResults: filtered.count)
            }
        } catch {
            if Task.isCancelled { return }
            await MainActor.run {
                output?.didFailToFetchSources(error)
            }
        }
    }
}
