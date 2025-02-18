//
//  BookListViewController.swift
//  BookLog
//
//  Created by 박지성 on 2/15/25.
//

import UIKit
import Combine
import os

final class BookListViewController: UIViewController {
    private let viewModel = BookListViewModel()
    
    private var cancellables = Set<AnyCancellable>()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BookListCell.self, forCellReuseIdentifier: "BookListCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내 서재"
        setupViews()
        setupBindings()
    }

    deinit {
        os_log("%{public}@ deinitialized.", type: .info, String(describing: self))
        cancellables.removeAll()
    }

    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    private func setupBindings() {
        viewModel.$books
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension BookListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookListCell", for: indexPath) as?
                BookListCell else {
            os_log("Failed to dequeue BookListCell", type: .error)
            return UITableViewCell()
        }
        cell.configure(with: viewModel.books[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = viewModel.books[indexPath.row]
        let bookReviewVC = BookReviewViewController()
        bookReviewVC.book = selectedBook
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
