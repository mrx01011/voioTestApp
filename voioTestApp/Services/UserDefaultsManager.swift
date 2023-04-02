//
//  UserDefaultsManager.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 02.04.2023.
//

import Foundation

class DataBase {
    static let shared = DataBase()
    let defaults = UserDefaults.standard
    let userKey = SettingKeys.users.rawValue
    let activeUserKey = SettingKeys.activeUser.rawValue
    var users: [User] {
        get {
            if let data = defaults.value(forKey: userKey) as? Data {
                return try! PropertyListDecoder().decode([User].self, from: data)
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
                return try! PropertyListDecoder().decode(User.self, from: data)
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
    
    func saveUser(firstName: String, lastName: String, email: String, password: String, age: Date, avatarURL: URL?) {
        let user = User(firstName: firstName, lastName: lastName, email: email, password: password, age: age, avatarURL: avatarURL)
        users.insert(user, at: 0)
    }
    
    func saveActiveUser(user: User) {
        activeUser = user
    }
    
}
//MARK: - SettingKeys
extension DataBase {
    enum SettingKeys: String {
        case users
        case activeUser
    }
}
