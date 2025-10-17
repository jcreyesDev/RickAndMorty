//
//  CharacterGridView.swift
//  RickAndMorty
//
//  Created by Julio César Reyes on 16/10/2025.
//

import SwiftUI

// MARK: - CharacterGridView
struct CharacterGridView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    @State private var statusFilter: StatusFilter = .all
    
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 14)
    ]
    
    private var filtered: [Character] {
        let bySearch = viewModel.filteredCharacters
        switch statusFilter {
            case .all:     return bySearch
            case .alive:   return bySearch.filter { $0.status.caseInsensitiveCompare("Alive") == .orderedSame }
            case .dead:    return bySearch.filter { $0.status.caseInsensitiveCompare("Dead")  == .orderedSame }
            case .unknown: return bySearch.filter { $0.status.caseInsensitiveCompare("Unknown") == .orderedSame }
        }
    }
    
    private var filterSegmented: some View {
        Picker("Status", selection: $statusFilter) {
            ForEach(StatusFilter.allCases, id: \.self) { filter in
                Text(filter.title).tag(filter)
            }
        }
        .pickerStyle(.segmented)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                filterSegmented
                    .padding(.horizontal)
                
                Group {
                    switch viewModel.state {
                        case .idle:
                            ProgressView("Loading characters...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        case .loading where viewModel.characters.isEmpty:
                            ProgressView("Loading characters...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        case .error(let message) where viewModel.characters.isEmpty:
                            VStack(spacing: 12) {
                                Text("❌ \(message)")
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                Button("Retry") {
                                    Task { await viewModel.loadCharacters(reset: true) }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        default:
                            if filtered.isEmpty {
                                ContentUnavailableView(
                                    "No results",
                                    systemImage: "person.crop.square.filled.and.at.rectangle",
                                    description: Text("Try another term or change the filter.")
                                )
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 14) {
                                        ForEach(filtered.indices, id: \.self) { index in
                                            let character = filtered[index]
                                            
                                            NavigationLink {
                                                CharacterDetailView(character: character)
                                            } label: {
                                                CharacterCardView(character: character)
                                            }
                                            .buttonStyle(.plain)
                                            .task {
                                                if index == filtered.count - 1 {
                                                    await viewModel.loadCharacters()
                                                }
                                            }
                                        }
                                        
                                        if viewModel.state == .loading && !viewModel.characters.isEmpty {
                                            ProgressView("Loading more characters...")
                                                .padding(.vertical, 16)
                                                .frame(maxWidth: .infinity)
                                                .gridCellColumns(columns.count)
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.bottom, 16)
                                }
                                .refreshable {
                                    await viewModel.loadCharacters(reset: true)
                                }
                            }
                    }
                }
                .animation(.easeInOut, value: viewModel.state)
            }
            .navigationTitle("Rick & Morty")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isNetworkBusy {
                        ProgressView()
                    }
                }
            }
        }
        .task {
            await viewModel.loadCharacters(reset: true)
        }
    }
}

// MARK: - SearchBar View
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search characters...", text: $text)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

enum StatusFilter: CaseIterable {
    case all, alive, dead, unknown
    
    var title: String {
        switch self {
            case .all: return "All"
            case .alive: return "Alive"
            case .dead: return "Dead"
            case .unknown: return "Unknown"
        }
    }
}
