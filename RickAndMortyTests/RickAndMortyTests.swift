//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Julio César Reyes on 16/10/2025.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class RickAndMortyTests: XCTestCase {
    
    // MARK: - MockAPIClient
    final class MockAPIClient: APIClient {
        var shouldFail = false
        
        var stubbedResponse = CharacterResponse(results: [Character(id: 1,
                                                                    name: "Rick Sanchez",
                                                                    status: "Alive",
                                                                    species: "Human",
                                                                    gender: "Male",
                                                                    image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                                                    origin: Origin(name: "Earth (C-137)"),
                                                                    location: Location(name: "Citadel of Ricks")),
                                                          Character(id: 2,
                                                                    name: "Morty Smith",
                                                                    status: "Alive",
                                                                    species: "Human",
                                                                    gender: "Male",
                                                                    image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
                                                                    origin: Origin(name: "unknown"),
                                                                    location: Location(name: "Earth (Replacement Dimension)"))],
                                                info: Info(count: 826,
                                                           pages: 42,
                                                           next: "https://rickandmortyapi.com/api/character?page=2",
                                                           prev: nil))
        
        func fetchCharacters(page: Int) async throws -> CharacterResponse {
            if shouldFail { throw APIError.invalidResponse }
            return stubbedResponse
        }
    }
    
    // MARK: - Tests
    func test_loadCharacters_success() async {
        let api = MockAPIClient()
        let vm = CharacterListViewModel(apiService: api)
        
        await vm.loadCharacters(reset: true)
        
        XCTAssertEqual(vm.characters.count, 2)
        XCTAssertEqual(vm.characters.first?.name, "Rick Sanchez")
        XCTAssertEqual(vm.state, .success)
    }
    
    func test_loadCharacters_failure() async {
        let api = MockAPIClient()
        api.shouldFail = true
        let vm = CharacterListViewModel(apiService: api)
        
        await vm.loadCharacters(reset: true)
        
        if case .error(let msg) = vm.state {
            XCTAssertFalse(msg.isEmpty, "Error message should not be empty")
        } else {
            XCTFail("Expected .error state")
        }
    }
    
    func test_searchFilter_caseInsensitive() async {
        let api = MockAPIClient()
        let vm = CharacterListViewModel(apiService: api)
        await vm.loadCharacters(reset: true)
        
        vm.searchText = "morty"
        
        XCTAssertEqual(vm.filteredCharacters.count, 1)
        XCTAssertEqual(vm.filteredCharacters.first?.name, "Morty Smith")
    }
    
    func test_networkBusy_flag_turns_off() async {
        let api = MockAPIClient()
        let vm = CharacterListViewModel(apiService: api)
        
        XCTAssertFalse(vm.isNetworkBusy)
        await vm.loadCharacters(reset: true)
        XCTAssertFalse(vm.isNetworkBusy)
    }
}
