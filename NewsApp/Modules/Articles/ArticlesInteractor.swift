//
//  ArticlesInteractor.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import Foundation

final class ArticlesInteractor: ArticlesInteractorProtocol {
    weak var output: ArticlesInteractorOutputProtocol?

    @concurrent
    func fetchArticles(sourceId: String, page: Int, pageSize: Int, searchQuery: String?) async {
        do {
            var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "sources", value: sourceId),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "pageSize", value: "\(pageSize)")
            ]
            if let searchQuery, !searchQuery.isEmpty {
                queryItems.append(URLQueryItem(name: "q", value: searchQuery))
            }

            let response = try await NetworkService.shared.fetch(
                ArticlesResponse.self,
                endpoint: "/everything",
                queryItems: queryItems
            )
            
            if Task.isCancelled { return }

            await MainActor.run {
                output?.didFetchArticles(
                    response.articles,
                    rawCount: response.rawArticleCount,
                    totalResults: response.totalResults
                )
            }
        } catch {
            if Task.isCancelled { return }
            
            await MainActor.run {
                output?.didFailToFetchArticles(error)
            }
        }
    }
}
