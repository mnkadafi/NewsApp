//
//  SourcesRouter.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI

final class SourcesRouter: SourcesRouterProtocol {
    static func createModule(category: NewsCategory) -> AnyView {
        let interactor = SourcesInteractor()
        let presenter = SourcesPresenter(interactor: interactor, category: category)
        let router = SourcesRouter()

        interactor.output = presenter
        presenter.router = router

        return AnyView(SourcesView(presenter: presenter))
    }

    func navigateToArticles(for source: NewsSource) -> AnyView {
        ArticlesRouter.createModule(source: source)
    }
}
