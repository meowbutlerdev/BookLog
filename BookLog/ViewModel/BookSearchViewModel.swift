//
//  BookSearchViewModel.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//

import Foundation
import CoreData
import os

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
                    os_log("API Error: %{public}@", type: .error, error.localizedDescription)
                }
            }
        }
    }

    func addBookToLibrary(from bookResponse: BookAPIResponse) {
        let context = CoreDataManager.shared.context
        let newBook = Book(context: context)

        newBook.id = UUID()
        newBook.title = bookResponse.volumeInfo.title
        newBook.author = bookResponse.volumeInfo.authors?.joined(separator: ", ")
        newBook.publishedDate = bookResponse.volumeInfo.publishedDate
        newBook.thumbnail = bookResponse.volumeInfo.imageLinks?.thumbnail
        newBook.createdAt = Date()

        do {
            try context.save()
        } catch {
            os_log("Failed to save book: %{public}@", type: .error, error.localizedDescription)
        }
    }
}
