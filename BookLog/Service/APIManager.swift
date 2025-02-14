//
//  APIManager.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    private init() {}

    private let baseURL = ""
    private let apiKey = ""

    func fetchBooks(query: String, completion: @escaping (Result<[BookAPIResponse], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "maxResults", value: "20")
        ]

        guard let url = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decodeResponse = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
                completion(.success(decodeResponse.items))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
