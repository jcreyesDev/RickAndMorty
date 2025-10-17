//
//  Character.swift
//  RickAndMorty
//
//  Created by Julio César Reyes on 16/10/2025.
//

import Foundation

struct Character: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let origin: Origin
    let location: Location
}

struct Origin: Codable, Equatable {
    let name: String
}

struct Location: Codable, Equatable {
    let name: String
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct CharacterResponse: Codable {
    let results: [Character]
    let info: Info
}
