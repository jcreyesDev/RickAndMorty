//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Julio César Reyes on 16/10/2025.
//

import Foundation

// MARK: - CharacterListViewModel
@MainActor
final class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var state: ViewState = .idle
    @Published var searchText: String = ""
    @Published var isNetworkBusy: Bool = false
    
    private let api: APIClient
    private var currentPage = 1
    private var canLoadMore = true
    private var isLoadingPage = false
    
    init(apiService: APIClient = APIService.shared) {
        self.api = apiService
    }
    
    func loadCharacters(reset: Bool = false) async {
        guard !isLoadingPage else { return }
        guard canLoadMore || reset else { return }
        
        isLoadingPage = true
        isNetworkBusy = true
        
        defer {
            isLoadingPage = false
            isNetworkBusy = false
        }
        
        if reset {
            currentPage = 1
            canLoadMore = true
            characters.removeAll()
        }
        
        if characters.isEmpty { state = .loading }
        
        do {
            let response = try await api.fetchCharacters(page: currentPage)
            let newCharacters = response.results
            
            if reset {
                characters = newCharacters
            } else {
                characters.append(contentsOf: newCharacters)
            }
            
            canLoadMore = response.info.next != nil
            if canLoadMore { currentPage += 1 }
            
            state = .success
        } catch {
            state = .error(error.localizedDescription)
        }
        
        isLoadingPage = false
    }
    
    var filteredCharacters: [Character] {
        guard !searchText.isEmpty else { return characters }
        return characters.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}

// MARK: - ViewModel State
enum ViewState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}
