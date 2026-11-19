//
//  ArticleDetailRouter.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//

import SwiftUI

final class ArticleDetailRouter: ArticleDetailRouterProtocol {
    static func createModule(article: NewsArticle) -> AnyView {
        let interactor = ArticleDetailInteractor()
        let presenter = ArticleDetailPresenter(interactor: interactor, article: article)
        return AnyView(ArticleDetailView(presenter: presenter))
    }
}
