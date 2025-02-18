//
//  BookListViewController.swift
//  BookLog
//
//  Created by 박지성 on 2/15/25.
//

import UIKit
import Combine

final class BookListViewController: UIViewController {
    private let viewModel = BookListViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내 서재"
        view.backgroundColor = .white
        setupTableView()
        setupBindings()
    }

    deinit {
        cancellables.removeAll()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookListCell.self, forCellReuseIdentifier: "BookListCell")
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    private func setupBindings() {
        viewModel.$books.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.beginUpdates()
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                self?.tableView.endUpdates()
            }
        }.store(in: &cancellables)
    }
}

extension BookListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookListCell", for: indexPath) as?
                BookListCell else {
            fatalError("Failed to dequeue BookListCell")
        }
        let book = viewModel.books[indexPath.row]
        cell.configure(with: book)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = viewModel.books[indexPath.row]
        let bookReviewVC = BookReviewViewController()
        bookReviewVC.existingBook = selectedBook
//        bookReviewVC.viewModel = viewModel
        navigationController?.pushViewController(bookReviewVC, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteBook(viewModel.books[indexPath.row])
        }
    }
}
