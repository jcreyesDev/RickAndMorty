//
//  CharacterCardView.swift
//  RickAndMorty
//
//  Created by Julio César Reyes on 16/10/2025.
//

import SwiftUI

// MARK: - CharacterCardView
struct CharacterCardView: View {
    let character: Character
    
    private var statusColor: Color {
        switch character.status.lowercased() {
            case "alive": return .green
            case "dead": return .red
            default: return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            CachedAsyncImage(url: character.image, placeholder: AnyView(ProgressView()))
                .frame(height: 140)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay(alignment: .topTrailing) {
                    statusBadge
                        .padding(8)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(character.species)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
    
    private var statusBadge: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            Text(character.status)
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.45))
        .clipShape(Capsule())
    }
}
