//
//  APIService.swift
//  RickAndMorty
//
//  Created by Julio César Reyes on 16/10/2025.
//

import Foundation

// MARK: - APIService
final class APIService: APIClient {
    
    static let shared = APIService()
    
    private let baseURL = "https://rickandmortyapi.com/api"
    private let session: URLSession
    
    private static func makeDefaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                                   diskCapacity: 200 * 1024 * 1024,
                                   diskPath: "rickandmorty_cache")
        return URLSession(configuration: config)
    }
    
    init(session: URLSession = APIService.makeDefaultSession()) {
        self.session = session
    }
    
    // MARK: - APIClient
    func fetchCharacters(page: Int = 1) async throws -> CharacterResponse {
        guard let url = URL(string: "\(baseURL)/character?page=\(page)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse,
              (200 ... 299).contains(http.statusCode) else {
            throw APIError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(CharacterResponse.self, from: data)
        } catch {
            throw APIError.decodingError(error.localizedDescription)
        }
    }
}

// MARK: - APIError
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "The request URL is invalid."
            case .invalidResponse:
                return "The server response was not valid."
            case .decodingError(let message):
                return "Decoding error: \(message)"
            case .unknown:
                return "An unknown error occurred."
        }
    }
}
