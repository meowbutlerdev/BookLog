//
//  BookListViewModel.swift
//  BookLog
//
//  Created by 박지성 on 2/15/25.
//

import Foundation
import CoreData

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

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            books = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Fetch Failed: \(error)")
        }
    }

    func addBook(title: String, author: String, thumbnail: String?) {
        let newBook = Book(context: context)
        newBook.id = UUID()
        newBook.title = title
        newBook.author = author
        newBook.thumbnail = thumbnail
        newBook.createdAt = Date()

        saveContext()
    }

    func deleteBook(_ book: Book) {
        context.delete(book)
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
