//
//  BookListViewModel.swift
//  BookLog
//
//  Created by 박지성 on 2/15/25.
//

import Foundation
import CoreData
import os

final class BookListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    private let context = CoreDataManager.shared.context
    private var fetchedResultsController: NSFetchedResultsController<Book>!

    @Published var books: [Book] = []

    override init() {
        super.init()
        setupFetchedResultsController()
    }

    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.fetchBatchSize = 20

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            books = fetchedResultsController.fetchedObjects ?? []
        } catch {
            os_log("Fetch Failed: %{public}@", type: .error, error.localizedDescription)
        }
    }

    func deleteBook(_ book: Book) {
        context.delete(book)
        saveContext()
    }

    func updateBook(_ book: Book, newTitle: String, newAuthor: String) {
        book.title = newTitle
        book.author = newAuthor
        saveContext()
    }

    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        if let fetchedBooks = controller.fetchedObjects as? [Book] {
            self.books = fetchedBooks
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didUpdateBookList, object: nil)
        }
    }
}

extension Notification.Name {
    static let didUpdateBookList = Notification.Name("didUpdateBookList")
}
