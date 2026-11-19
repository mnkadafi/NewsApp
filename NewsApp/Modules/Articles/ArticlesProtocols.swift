//
//  ArticlesProtocols.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI

protocol ArticlesInteractorProtocol: AnyObject {
    var output: ArticlesInteractorOutputProtocol? { get set }
    func fetchArticles(sourceId: String, page: Int, pageSize: Int, searchQuery: String?) async
}

protocol ArticlesInteractorOutputProtocol: AnyObject {
    func didFetchArticles(_ articles: [NewsArticle], rawCount: Int, totalResults: Int)
    func didFailToFetchArticles(_ error: Error)
}

protocol ArticlesPresenterProtocol: AnyObject {
    var articles: [NewsArticle] { get }
    var state: ViewState { get }
    var isLoadingMore: Bool { get }
    var canLoadMore: Bool { get }
    var router: ArticlesRouterProtocol? { get set }

    func viewDidLoad()
    func loadMoreArticles()
    func searchArticles(query: String)
    func refresh()
}

protocol ArticlesRouterProtocol: AnyObject {
    static func createModule(source: NewsSource) -> AnyView
    func navigateToArticleDetail(for article: NewsArticle) -> AnyView
}
