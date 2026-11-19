//
//  ArticlesView.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI

struct ArticlesView: View {
    @State private var presenter: ArticlesPresenter
    @State private var searchText = ""

    init(presenter: ArticlesPresenter) {
        _presenter = State(wrappedValue: presenter)
    }

    var body: some View {
        content
            .navigationTitle("Articles")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search articles")
            .onChange(of: searchText) { _, newValue in
                presenter.searchArticles(query: newValue)
            }
            .onAppear { presenter.viewDidLoad() }
            .refreshable { presenter.refresh() }
            .navigationDestination(for: NewsArticle.self) { article in
                if let router = presenter.router {
                    router.navigateToArticleDetail(for: article)
                } else {
                    EmptyView()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if presenter.articles.isEmpty {
            emptyState
        } else {
            listContent
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        switch presenter.state {
        case .idle, .loading:
            ProgressView("Loading articles…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let message):
            ContentUnavailableView {
                Label("Error", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") { presenter.refresh() }
                    .buttonStyle(.borderedProminent)
            }

        case .loaded:
            ContentUnavailableView(
                "No Articles",
                systemImage: "doc.text",
                description: Text("No articles match your search.")
            )
        }
    }

    private var listContent: some View {
        List {
            ForEach(presenter.articles) { article in
                NavigationLink(value: article) {
                    ArticleRow(article: article)
                }
                .onAppear {
                    if article == presenter.articles.last {
                        presenter.loadMoreArticles()
                    }
                }
            }
            if presenter.isLoadingMore {
                HStack { Spacer(); ProgressView(); Spacer() }
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

private struct ArticleRow: View {
    let article: NewsArticle
    var body: some View {
        HStack(spacing: 12) {
            thumbnail
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let desc = article.description {
                    Text(desc).font(.subheadline).foregroundStyle(.secondary).lineLimit(2)
                }
                
                Text(article.source.name).font(.caption).foregroundStyle(.blue)
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                case .failure:
                    Color
                        .gray
                        .opacity(0.3)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundStyle(.secondary)
                        )
                    
                default:
                    ProgressView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
        }
    }
}
