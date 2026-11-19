//
//  ArticleDetailProtocols.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI

protocol ArticleDetailInteractorProtocol: AnyObject {
    func validatedURL(from urlString: String) -> URL?
}

protocol ArticleDetailPresenterProtocol: AnyObject {
    var url: URL? { get }
    var isLoading: Bool { get }
    func viewDidLoad()
    func setLoading(_ loading: Bool)
}

protocol ArticleDetailRouterProtocol: AnyObject {
    static func createModule(article: NewsArticle) -> AnyView
}
