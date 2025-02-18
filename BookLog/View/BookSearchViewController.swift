//
//  BookSearchViewController.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//

import UIKit
import Combine
import os

final class BookSearchViewController: UIViewController {
    private let viewModel = BookSearchViewModel()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "책 검색"
        setupViews()
        setupBindings()
    }

    deinit {
        os_log("%{public}@ deinitialized.", type: .info, String(describing: self))
        cancellables.removeAll()
    }

    private func setupViews() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookListCell.self, forCellReuseIdentifier: "BookListCell")

        [searchBar, tableView, activityIndicator].forEach { view.addSubview($0) }

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.$books
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.tableView.reloadData() }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { message in os_log("Error: %{public}@", message) }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchBooks(query: query)
        searchBar.resignFirstResponder()
    }
}

extension BookSearchViewController: UITableViewDataSource, UITableViewDelegate {
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
}
