//
//  NewsCategory.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import Foundation

nonisolated enum NewsCategory: String, CaseIterable, Identifiable, Sendable {
    case general, business, entertainment, health, science, sports, technology

    var id: String { rawValue }
    var title: String {
        switch self {
        case .general: "General"
        case .business: "Business"
        case .entertainment: "Entertainment"
        case .health: "Health"
        case .science: "Science"
        case .sports: "Sports"
        case .technology: "Technology"
        }
    }
    var systemImage: String {
        switch self {
        case .general: "newspaper"
        case .business: "briefcase"
        case .entertainment: "film"
        case .health: "heart"
        case .science: "atom"
        case .sports: "sportscourt"
        case .technology: "cpu"
        }
    }
}
