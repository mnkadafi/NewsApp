//
//  CategoriesInteractor.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//

import Foundation

final class CategoriesInteractor: CategoriesInteractorProtocol {
    func fetchCategories() -> [NewsCategory] {
        NewsCategory.allCases
    }
}
