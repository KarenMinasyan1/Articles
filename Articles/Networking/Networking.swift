//
//  Networking.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

class Networking {
    static func getRequest<T: Codable>(url: String, path: String, params: [String: String], responseType: T.Type, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .formatted(Formatter.iso8601), completion: @escaping (T?, Error?) -> Void)
    {
        var urlComponents = URLComponents(string: url)
        urlComponents?.path = path
        urlComponents?.setQueryItems(with: params)
        
        guard let url = urlComponents?.url else {
            completion(nil, AppError.wrongURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error {
                    completion(nil, error)
                    print(error.localizedDescription)
                    return
                }
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = dateDecodingStrategy
                    let responseModel = try decoder.decode(T.self, from: data)
                    completion(responseModel, nil)
                }
            } catch let error {
                completion(nil, error)
                print(error.localizedDescription)
                return
            }
        }.resume()
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
}
