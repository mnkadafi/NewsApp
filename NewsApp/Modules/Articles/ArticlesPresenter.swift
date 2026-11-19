//
//  ArticlesPresenter.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI
import Observation

@Observable
@MainActor
final class ArticlesPresenter: ArticlesPresenterProtocol, ArticlesInteractorOutputProtocol {
    var router: ArticlesRouterProtocol?
    private(set) var articles: [NewsArticle] = []
    private(set) var state: ViewState = .idle
    private(set) var isLoadingMore = false
    private(set) var canLoadMore = true

    private let interactor: ArticlesInteractorProtocol
    private let source: NewsSource
    private let pageSize = 20

    private var currentPage = 1
    private var searchQuery = ""
    private var searchTask: Task<Void, Never>?
    private var fetchTask: Task<Void, Never>?

    init(interactor: ArticlesInteractorProtocol, source: NewsSource) {
        self.interactor = interactor
        self.source = source
    }

    func viewDidLoad() {
        guard state == .idle else { return }
        loadFirstPage()
    }

    func loadMoreArticles() {
        guard canLoadMore, !isLoadingMore, state == .loaded else { return }
        isLoadingMore = true
        let q = searchQuery.isEmpty ? nil : searchQuery
        Task {
            await interactor.fetchArticles(sourceId: source.id, page: currentPage + 1, pageSize: pageSize, searchQuery: q)
        }
    }

    func searchArticles(query: String) {
        searchQuery = query
        searchTask?.cancel()
        fetchTask?.cancel()

        articles = []
        state = .loading

        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            loadFirstPage()
        }
    }

    func refresh() {
        searchTask?.cancel()
        fetchTask?.cancel()
        loadFirstPage()
    }

    private func loadFirstPage() {
        currentPage = 1
        canLoadMore = true
        state = .loading
        let q = searchQuery.isEmpty ? nil : searchQuery

        fetchTask?.cancel()
        fetchTask = Task {
            await interactor.fetchArticles(
                sourceId: source.id,
                page: 1,
                pageSize: pageSize,
                searchQuery: q
            )
        }
    }

    // MARK: ArticlesInteractorOutputProtocol
    func didFetchArticles(_ articles: [NewsArticle], rawCount: Int, totalResults: Int) {
        guard !Task.isCancelled else { return }

        if currentPage == 1 {
            self.articles = articles
        } else {
            self.articles.append(contentsOf: articles)
        }
        
        let apiReturnedShort = rawCount < pageSize
        let apiExhausted = (currentPage * pageSize) >= totalResults

        if apiReturnedShort || apiExhausted {
            canLoadMore = false
        } else {
            currentPage += 1
        }

        state = .loaded
        isLoadingMore = false
    }

    func didFailToFetchArticles(_ error: Error) {
        guard !Task.isCancelled else { return }
        if (error as? CancellationError) != nil { return }
        
        state = .error(error.localizedDescription)
        isLoadingMore = false
    }
}
