//
//  SourcesView.swift
//  NewsApp
//
//  Created by Mochamad Nurkhayal Kadafi on 18/11/26.
//


import SwiftUI

struct SourcesView: View {
    @State private var presenter: SourcesPresenter
    @State private var searchText = ""

    init(presenter: SourcesPresenter) {
        _presenter = State(wrappedValue: presenter)
    }

    var body: some View {
        content
            .navigationTitle("Sources")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search sources")
            .onChange(of: searchText) { _, newValue in
                presenter.searchSources(query: newValue)
            }
            .onAppear { presenter.viewDidLoad() }
            .refreshable { presenter.refresh() }
            .navigationDestination(for: NewsSource.self) { source in
                if let router = presenter.router {
                    router.navigateToArticles(for: source)
                } else {
                    EmptyView()
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if presenter.sources.isEmpty {
            emptyState
        } else {
            listContent
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        switch presenter.state {
        case .idle, .loading:
            ProgressView("Loading sources…")
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
                "No Sources",
                systemImage: "newspaper",
                description: Text("No sources match your search.")
            )
        }
    }

    private var listContent: some View {
        List {
            ForEach(presenter.sources) { source in
                NavigationLink(value: source) {
                    SourceRow(source: source)
                }
                .onAppear {
                    if source == presenter.sources.last {
                        presenter.loadMoreSources()
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

private struct SourceRow: View {
    let source: NewsSource
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(source.name).font(.headline)
            if let desc = source.description, !desc.isEmpty {
                Text(desc).font(.subheadline).foregroundStyle(.secondary).lineLimit(2)
            }
            HStack(spacing: 8) {
                if let c = source.category {
                    Text(c.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 8).padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1)).clipShape(Capsule())
                }
                if let country = source.country {
                    Text(country.uppercased()).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
