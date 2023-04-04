//
//  UserModel.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 02.04.2023.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let age: Date
    let avatarURL: URL?
    let favouritesFilms: [Film]?
}
