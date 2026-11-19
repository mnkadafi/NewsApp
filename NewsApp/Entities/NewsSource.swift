//
//  NewsSource.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import Foundation

nonisolated struct NewsSource: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?
}

nonisolated struct SourcesResponse: Codable, Sendable {
    let status: String
    let sources: [NewsSource]
}
