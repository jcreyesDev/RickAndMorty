//
//  ImageCacheService.swift
//  RickAndMorty
//
//  Created by Julio César Reyes on 16/10/2025.
//

import SwiftUI

// MARK: - ImageCacheService
final class ImageCacheService {
    static let shared = ImageCacheService()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    func loadImage(from urlString: String) async throws -> UIImage {
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200 ..< 300).contains(httpResponse.statusCode),
              let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        
        cache.setObject(image, forKey: urlString as NSString)
        return image
    }
}
