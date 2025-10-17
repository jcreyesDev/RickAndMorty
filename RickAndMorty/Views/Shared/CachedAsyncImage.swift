//
//  CachedAsyncImage.swift
//  RickAndMorty
//
//  Created by Julio César Reyes on 16/10/2025.
//

import SwiftUI

// MARK: - CachedAsyncImage
struct CachedAsyncImage: View {
    let url: String
    let placeholder: AnyView?
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                placeholder ?? AnyView(ProgressView())
            } else {
                placeholder ?? AnyView(Color(.secondarySystemBackground))
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard !isLoading else { return }
        isLoading = true
        do {
            let loaded = try await ImageCacheService.shared.loadImage(from: url)
            image = loaded
        } catch {
            print("❌ Failed to load image: \(error.localizedDescription)")
        }
        isLoading = false
    }
}
