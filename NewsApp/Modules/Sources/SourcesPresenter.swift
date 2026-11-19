//
//  SourcesPresenter.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI
import Observation

@Observable
@MainActor
final class SourcesPresenter: SourcesPresenterProtocol, SourcesInteractorOutputProtocol {
    var router: SourcesRouterProtocol?
    private(set) var sources: [NewsSource] = []
    private(set) var state: ViewState = .idle
    private(set) var isLoadingMore = false
    private(set) var canLoadMore = true

    private let interactor: SourcesInteractorProtocol
    private let category: NewsCategory
    private let pageSize = 20

    private var currentPage = 1
    private var searchQuery = ""
    private var searchTask: Task<Void, Never>?

    init(interactor: SourcesInteractorProtocol, category: NewsCategory) {
        self.interactor = interactor
        self.category = category
    }

    func viewDidLoad() {
        guard state == .idle else { return }
        loadFirstPage()
    }

    func loadMoreSources() {
        guard canLoadMore, !isLoadingMore, state == .loaded else { return }
        isLoadingMore = true
        let q = searchQuery.isEmpty ? nil : searchQuery
        
        Task {
            await interactor.fetchSources(category: category, page: currentPage + 1, pageSize: pageSize, searchQuery: q)
        }
    }

    func searchSources(query: String) {
        searchQuery = query
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            loadFirstPage()
        }
    }

    func refresh() { loadFirstPage() }

    private func loadFirstPage() {
        currentPage = 1
        canLoadMore = true
        state = .loading
        let q = searchQuery.isEmpty ? nil : searchQuery
        Task {
            await interactor.fetchSources(category: category, page: 1, pageSize: pageSize, searchQuery: q)
        }
    }

    // MARK: SourcesInteractorOutputProtocol
    func didFetchSources(_ sources: [NewsSource], totalResults: Int) {
        if currentPage == 1 {
            self.sources = sources
        } else {
            self.sources.append(contentsOf: sources)
        }

        if sources.count < pageSize || self.sources.count >= totalResults {
            canLoadMore = false
        } else {
            currentPage += 1
        }
        state = .loaded
        isLoadingMore = false
    }

    func didFailToFetchSources(_ error: Error) {
        state = .error(error.localizedDescription)
        isLoadingMore = false
    }
}
