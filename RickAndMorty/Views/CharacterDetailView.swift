//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Julio César Reyes on 16/10/2025.
//

import SwiftUI

// MARK: - CharacterDetailView
struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HeaderImage(url: character.image)
                    .padding(.top, 8)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(character.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                        .accessibilityAddTraits(.isHeader)
                    
                    HStack(spacing: 8) {
                        StatusDot(status: character.status)
                        Text(character.status)
                            .font(.headline)
                    }
                    
                    Group {
                        InfoRow(label: "Species", value: character.species)
                        InfoRow(label: "Gender", value: character.gender)
                        InfoRow(label: "Origin", value: character.origin.name)
                        InfoRow(label: "Location", value: character.location.name)
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 24)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - HeaderImage
private struct HeaderImage: View {
    let url: String
    
    var body: some View {
        CachedAsyncImage(url: url, placeholder: AnyView(ProgressView()))
            .frame(maxWidth: .infinity)
            .aspectRatio(16/9, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 6)
            .padding(.horizontal)
    }
}

// MARK: - StatusDot
private struct StatusDot: View {
    let status: String
    var color: Color {
        switch status.lowercased() {
            case "alive": return .green
            case "dead":  return .red
            default:      return .gray
        }
    }
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 12, height: 12)
            .accessibilityHidden(true)
    }
}

// MARK: - InfoRow
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
        .font(.body)
    }
}
