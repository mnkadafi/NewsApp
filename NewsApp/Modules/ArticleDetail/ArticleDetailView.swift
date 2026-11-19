//
//  ArticleDetailView.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI

struct ArticleDetailView: View {
    @State private var presenter: ArticleDetailPresenter

    init(presenter: ArticleDetailPresenter) {
        _presenter = State(wrappedValue: presenter)
    }

    var body: some View {
        Group {
            if let url = presenter.url {
                ZStack {
                    WebView(url: url, isLoading: Binding(
                        get: { presenter.isLoading },
                        set: { presenter.setLoading($0) }
                    ))
                    if presenter.isLoading {
                        ProgressView().controlSize(.large)
                    }
                }
            } else {
                ContentUnavailableView(
                    "Invalid URL",
                    systemImage: "link.badge.plus",
                    description: Text("The article URL is invalid or unsupported.")
                )
            }
        }
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { presenter.viewDidLoad() }
    }
}
