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

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    private func setupBindings() {
        viewModel.$books.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
}

extension BookListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        let book = viewModel.books[indexPath.row]
        cell.textLabel?.text = book.title

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteBook(viewModel.books[indexPath.row])
        }
    }
}
