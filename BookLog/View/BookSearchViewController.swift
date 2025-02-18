//
//  BookSearchViewController.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//

import UIKit
import Combine

final class BookSearchViewController: UIViewController {
    private let viewModel = BookSearchViewModel()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "책 검색"
        setupViews()
        setupBindings()
    }

    deinit {
        cancellables.removeAll()
    }

    private func setupViews() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookListCell.self, forCellReuseIdentifier: "BookListCell")
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center

        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.$books.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        viewModel.$errorMessage.sink { errorMessage in
            if let message = errorMessage {
                print("Error: \(message)")
            }
        }.store(in: &cancellables)

        viewModel.$isLoading.sink { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }.store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()
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
            fatalError("Failed to dequeue BookListCell")
        }
        let book = viewModel.books[indexPath.row]
        cell.configure(with: book)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = viewModel.books[indexPath.row]
        let bookReviewVC = BookReviewViewController()

        bookReviewVC.book = selectedBook
        navigationController?.pushViewController(bookReviewVC, animated: true)
    }
}
