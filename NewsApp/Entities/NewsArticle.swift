//
//  NewsArticle.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import Foundation

nonisolated struct ArticleSource: Codable, Hashable, Sendable {
    let id: String?
    let name: String
}

nonisolated struct NewsArticle: Codable, Identifiable, Hashable, Sendable {
    let source: ArticleSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?

    var id: String { url }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        let rawTitle = try c.decodeIfPresent(String.self, forKey: .title)
        guard let title = rawTitle,
              !title.isEmpty,
              title != "[Removed]" else {
            throw DecodingError.dataCorruptedError(
                forKey: .title, in: c,
                debugDescription: "Article has no usable title"
            )
        }
        self.title = title

        let rawURL = try c.decodeIfPresent(String.self, forKey: .url)
        guard let url = rawURL, URL(string: url) != nil else {
            throw DecodingError.dataCorruptedError(
                forKey: .url, in: c,
                debugDescription: "Article has no usable URL"
            )
        }
        self.url = url

        let rawSource = try c.decodeIfPresent(ArticleSource.self, forKey: .source)
        guard let source = rawSource else {
            throw DecodingError.dataCorruptedError(
                forKey: .source, in: c,
                debugDescription: "Article has no source"
            )
        }
        self.source = source

        self.publishedAt = try c.decode(String.self, forKey: .publishedAt)

        self.author      = try c.decodeIfPresent(String.self, forKey: .author)
        self.description = try c.decodeIfPresent(String.self, forKey: .description)
        self.urlToImage  = try c.decodeIfPresent(String.self, forKey: .urlToImage)
        self.content     = try c.decodeIfPresent(String.self, forKey: .content)
    }
}

nonisolated struct ArticlesResponse: Codable, Sendable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
    let rawArticleCount: Int
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try c.decode(String.self, forKey: .status)
        self.totalResults = try c.decode(Int.self, forKey: .totalResults)

        var unkeyed = try c.nestedUnkeyedContainer(forKey: .articles)
        var valid: [NewsArticle] = []
        var raw = 0

        while !unkeyed.isAtEnd {
            raw += 1
            if let article = try? unkeyed.decode(NewsArticle.self) {
                valid.append(article)
            }
        }
        
        self.rawArticleCount = raw
        self.articles = valid
    }
}
