//
//  ArticlesRouter.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI

final class ArticlesRouter: ArticlesRouterProtocol {
    static func createModule(source: NewsSource) -> AnyView {
        let interactor = ArticlesInteractor()
        let presenter = ArticlesPresenter(interactor: interactor, source: source)
        let router = ArticlesRouter()

        interactor.output = presenter
        presenter.router = router

        return AnyView(ArticlesView(presenter: presenter))
    }

    func navigateToArticleDetail(for article: NewsArticle) -> AnyView {
        ArticleDetailRouter.createModule(article: article)
    }
}
