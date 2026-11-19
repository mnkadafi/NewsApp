//
//  CategoriesProtocols.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//

import SwiftUI

protocol CategoriesInteractorProtocol: AnyObject {
    func fetchCategories() -> [NewsCategory]
}

protocol CategoriesPresenterProtocol: AnyObject {
    var categories: [NewsCategory] { get }
    var router: CategoriesRouterProtocol? { get set }
    func viewDidLoad()
}

protocol CategoriesRouterProtocol: AnyObject {
    static func createModule() -> AnyView
    func navigateToSources(for category: NewsCategory) -> AnyView
}
