//
//  NetworkDataFetch.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 02.04.2023.
//

import Foundation

class NetworkDataFetch {
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchFilm(urlString: String, response: @escaping (FilmModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let films = try JSONDecoder().decode(FilmModel.self, from: data)
                    response(films, nil)
                } catch let jsonError {
//                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                response(nil, error)
            }
        }
    }
}
