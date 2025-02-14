//
//  BookSearchViewModel.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//

import Foundation

final class BookSearchViewModel: ObservableObject {
    @Published var books: [BookAPIResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func searchBooks(query: String) {
        guard !query.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        APIManager.shared.fetchBooks(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let books):
                    self?.books = books
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
