//
//  APIClient.swift
//  RickAndMorty
//
//  Created by Julio César Reyes on 16/10/2025.
//

import Foundation

protocol APIClient {
    func fetchCharacters(page: Int) async throws -> CharacterResponse
}
