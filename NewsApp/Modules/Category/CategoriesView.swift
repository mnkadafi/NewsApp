//
//  CategoriesView.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI

struct CategoriesView: View {
    @State private var presenter: CategoriesPresenter

    init(presenter: CategoriesPresenter) {
        _presenter = State(wrappedValue: presenter)
    }

    var body: some View {
        NavigationStack {
            List(presenter.categories) { category in
                NavigationLink(value: category) {
                    HStack {
                        Image(systemName: category.systemImage)
                            .foregroundStyle(.blue)
                            .frame(width: 30)
                        Text(category.title)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Categories")
            .navigationDestination(for: NewsCategory.self) { category in
                if let router = presenter.router {
                    router.navigateToSources(for: category)
                } else {
                    EmptyView()
                }
            }
            .onAppear { presenter.viewDidLoad() }
        }
    }
}
