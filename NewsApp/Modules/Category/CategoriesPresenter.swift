//
//  CategoriesPresenter.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI
import Observation

@Observable
@MainActor
final class CategoriesPresenter: CategoriesPresenterProtocol {
    var router: CategoriesRouterProtocol?
    private(set) var categories: [NewsCategory] = []

    private let interactor: CategoriesInteractorProtocol

    init(interactor: CategoriesInteractorProtocol) {
        self.interactor = interactor
    }

    func viewDidLoad() {
        categories = interactor.fetchCategories()
    }
}
