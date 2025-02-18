//
//  APIManager.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//

import Foundation
import os

final class APIManager {
    static let shared = APIManager()
    private init() {}

    enum APIError: Error {
        case invalidURL
        case noData
        case decodingFailed
        case networkError(Error)
    }

    private let baseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_BOOKS_BASE_URL") as? String else {
            os_log("Missing GOOGLE_BOOKS_BASE_URL in Info.plist.", type: .error)
            return ""
        }
        return url
    }()

    private let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_BOOKS_API_KEY") as? String else {
            os_log("Missing GOOGLE_BOOKS_API_KEY in Info.plist.", type: .error)
            return ""
        }
        return key
    }()

    func fetchBooks(query: String, completion: @escaping (Result<[BookAPIResponse], APIError>) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else {
            os_log("Invalid Base URL.", type: .error)
            completion(.failure(.invalidURL))
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "maxResults", value: "20")
        ]

        guard let url = urlComponents.url else {
            os_log("Failed to create URL from components.", type: .error)
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                os_log("Network error: %{public}@", type: .error, error.localizedDescription)
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                os_log("No data received", type: .error)
                completion(.failure(.noData))
                return
            }

            do {
                let decodeResponse = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
                completion(.success(decodeResponse.items))
            } catch {
                os_log("Decoding failed: %{public}@", type: .error, error.localizedDescription)
                completion(.failure(.decodingFailed))
            }
        }
        task.resume()
    }
}
