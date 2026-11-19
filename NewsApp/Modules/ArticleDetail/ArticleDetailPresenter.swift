//
//  ArticleDetailPresenter.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import Foundation
import Observation

@Observable
@MainActor
final class ArticleDetailPresenter: ArticleDetailPresenterProtocol {
    private(set) var url: URL?
    var isLoading = true

    private let interactor: ArticleDetailInteractorProtocol
    private let article: NewsArticle

    init(interactor: ArticleDetailInteractorProtocol, article: NewsArticle) {
        self.interactor = interactor
        self.article = article
    }

    func viewDidLoad() {
        url = interactor.validatedURL(from: article.url)
    }

    func setLoading(_ loading: Bool) {
        isLoading = loading
    }
}
