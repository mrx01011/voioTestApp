//
//  NetworkRequest.swift
//  voioTestApp
//
//  Created by Vladyslav Nhuien on 02.04.2023.
//

import Foundation

class NetworkRequest {
    static let shared = NetworkRequest()
    private init() {}
    
    func requestData(urlString: String, completion: @escaping (Result<Data,Error>) -> Void ) {
        guard let url = URL(string: urlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let data = data else { return }
                    completion(.success(data))
                }
            }
            task.resume()
    }
}
