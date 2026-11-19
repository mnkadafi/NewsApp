//
//  SourcesProtocols.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//

import SwiftUI

enum ViewState: Equatable {
    case idle, loading, loaded
    case error(String)
}

protocol SourcesInteractorProtocol: AnyObject {
    var output: SourcesInteractorOutputProtocol? { get set }
    func fetchSources(category: NewsCategory, page: Int, pageSize: Int, searchQuery: String?) async
}

protocol SourcesInteractorOutputProtocol: AnyObject {
    func didFetchSources(_ sources: [NewsSource], totalResults: Int)
    func didFailToFetchSources(_ error: Error)
}

protocol SourcesPresenterProtocol: AnyObject {
    var sources: [NewsSource] { get }
    var state: ViewState { get }
    var isLoadingMore: Bool { get }
    var canLoadMore: Bool { get }
    var router: SourcesRouterProtocol? { get set }

    func viewDidLoad()
    func loadMoreSources()
    func searchSources(query: String)
    func refresh()
}

protocol SourcesRouterProtocol: AnyObject {
    static func createModule(category: NewsCategory) -> AnyView
    func navigateToArticles(for source: NewsSource) -> AnyView
}
