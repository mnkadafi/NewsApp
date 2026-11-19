//
//  CategoriesRouter.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI

final class CategoriesRouter: CategoriesRouterProtocol {
    static func createModule() -> AnyView {
        let interactor = CategoriesInteractor()
        let presenter = CategoriesPresenter(interactor: interactor)
        let router = CategoriesRouter()

        presenter.router = router

        return AnyView(CategoriesView(presenter: presenter))
    }

    func navigateToSources(for category: NewsCategory) -> AnyView {
        SourcesRouter.createModule(category: category)
    }
}
