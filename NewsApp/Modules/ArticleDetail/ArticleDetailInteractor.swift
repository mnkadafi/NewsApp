//
//  ArticleDetailInteractor.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//

import Foundation

final class ArticleDetailInteractor: ArticleDetailInteractorProtocol {
    func validatedURL(from urlString: String) -> URL? {
        guard let url = URL(string: urlString),
              let scheme = url.scheme?.lowercased(),
              scheme == "http" || scheme == "https",
              url.host != nil else {
            return nil
        }
        return url
    }
}
