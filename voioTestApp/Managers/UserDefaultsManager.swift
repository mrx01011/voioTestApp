//
//  UserDefaultsManager.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 02.04.2023.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private let userKey = SettingKeys.users.rawValue
    private let activeUserKey = SettingKeys.activeUser.rawValue
    var users: [User]? {
        get {
            if let data = defaults.value(forKey: userKey) as? Data {
                return try? PropertyListDecoder().decode([User].self, from: data)
            } else {
                return [User]()
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: userKey)
            }
        }
    }
    
    var activeUser: User? {
        get {
            if let data = defaults.value(forKey: activeUserKey) as? Data {
                return try? PropertyListDecoder().decode(User.self, from: data)
            } else {
                return nil
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: activeUserKey)
            }
        }
    }
    
    private init() {}
    
    func saveUser(firstName: String, lastName: String, email: String, password: String, age: Date, avatarURL: URL?, favouritesFilms: [Film]) {
        let user = User(firstName: firstName, lastName: lastName,
                        email: email, password: password,
                        age: age, avatarURL: avatarURL,
                        favouritesFilms: favouritesFilms)
        users?.insert(user, at: 0)
    }
    
    func saveActiveUser(user: User) {
        activeUser = user
    }
    
    func addFavouriteFilm(_ film: Film) {
        if let favourites = activeUser?.favouritesFilms,
           let currentUser = activeUser {
            var updatedFavourites = favourites
            updatedFavourites.append(film)
            let updatedUser = User(firstName: currentUser.firstName, lastName: currentUser.lastName,
                                   email: currentUser.email, password: currentUser.password,
                                   age: currentUser.age, avatarURL: currentUser.avatarURL,
                                   favouritesFilms: updatedFavourites)
            activeUser = updatedUser
        }
    }
    
    func deleteFavouriteFilm(_ film: Film) {
        if let favourites = activeUser?.favouritesFilms,
           let currentUser = activeUser {
            var updatedFavourites = favourites
            updatedFavourites.removeAll { $0.trackName == film.trackName }
            let updatedUser = User(firstName: currentUser.firstName, lastName: currentUser.lastName,
                                   email: currentUser.email, password: currentUser.password,
                                   age: currentUser.age, avatarURL: currentUser.avatarURL,
                                   favouritesFilms: updatedFavourites)
            activeUser = updatedUser
        }
    }
    
    func isFavouriteFilm(_ film: Film) -> Bool {
        guard let activeUser = activeUser,
              let favourites = activeUser.favouritesFilms else { return false }
        if favourites.contains(where: { $0.trackName == film.trackName }) {
            return true
        }
        return false
    }
}
//MARK: - SettingKeys
extension UserDefaultsManager {
    enum SettingKeys: String {
        case users
        case activeUser
    }
}
