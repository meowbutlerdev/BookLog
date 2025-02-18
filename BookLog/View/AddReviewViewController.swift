//
//  AddReviewViewController.swift
//  BookLog
//
//  Created by 박지성 on 2/17/25.
//

import UIKit

final class AddReviewViewController: UIViewController {
    var book: BookAPIResponse?

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let publishedDateLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    private let reviewTextView = UITextView()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        titleLabel.text = book?.volumeInfo.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 3

        authorLabel.text = book?.volumeInfo.authors?.joined(separator: ", ") ?? "저자 없음"
        authorLabel.font = UIFont.systemFont(ofSize: 18)

        publishedDateLabel.text = book?.volumeInfo.publishedDate ?? "발행일 없음"
        publishedDateLabel.font = UIFont.systemFont(ofSize: 18)

        if let url = URL(string: book?.volumeInfo.imageLinks?.thumbnail ?? "") {
            thumbnailImageView.sd_setImage(with: url,
                                           placeholderImage: UIImage(systemName: "책 이미지"),
                                           options: .refreshCached)
        }
        thumbnailImageView.contentMode = .scaleAspectFit

        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        reviewTextView.layer.cornerRadius = 8
        reviewTextView.font = UIFont.systemFont(ofSize: 16)
        reviewTextView.isScrollEnabled = true

        saveButton.setTitle("저장", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        let infoStackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel,
                                                           publishedDateLabel, thumbnailImageView])
        infoStackView.axis = .vertical
        infoStackView.spacing = 8

        let mainStackView = UIStackView(arrangedSubviews: [infoStackView,// ratingContainer,
                                                           reviewTextView, saveButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20 ),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reviewTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }

    @objc private func saveButtonTapped() {
        guard let book = book else { return }
        let context = CoreDataManager.shared.context

        let newBook = Book(context: context)
        newBook.id = UUID()
        newBook.title = book.volumeInfo.title
        newBook.author = book.volumeInfo.authors?.joined(separator: ", ")
        newBook.publishedDate = book.volumeInfo.publishedDate
        newBook.thumbnail = book.volumeInfo.imageLinks?.thumbnail
        newBook.createdAt = Date()

        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }

        navigationController?.popViewController(animated: true)
    }
}
