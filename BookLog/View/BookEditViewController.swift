//
//  BookEditViewController.swift
//  BookLog
//
//  Created by 박지성 on 2/15/25.
//

import UIKit

final class BookEditViewController: UIViewController {
    var book: Book?
    var viewModel: BookListViewModel?

    private let titleTextField = UITextField()
    private let authorTextField = UITextField()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        titleTextField.text = book?.title
        authorTextField.text = book?.author

        saveButton.setTitle("저장", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [titleTextField, authorTextField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func saveTapped() {
        guard let book = book,
              let viewModel = viewModel,
              let newTitle = titleTextField.text,
              let netAuthor = authorTextField.text else { return }

        viewModel.updateBook(book, newTitle: newTitle, newAuthor: netAuthor)
        navigationController?.popViewController(animated: true)
    }
}
