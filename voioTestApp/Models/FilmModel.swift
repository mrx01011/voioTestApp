//
//  FilmModel.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 02.04.2023.
//

import Foundation

struct FilmModel: Codable {
    let results: [Film]
}

struct Film: Codable {
    let trackName: String?
    let artworkUrl100: String?
    let releaseDate: String?
    let primaryGenreName: String?
    let longDescription: String?
    let collectionViewURL: String?
}
