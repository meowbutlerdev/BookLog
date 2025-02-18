//
//  BookReviewViewController.swift
//  BookLog
//
//  Created by 박지성 on 2/17/25.
//

import UIKit
import os

final class BookReviewViewController: UIViewController {
    var book: BookDisplayable?

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let publishedDateLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    private let reviewTextView = UITextView()
    private let ratingView = UIStackView()
    private let ratingContainer = UIView()
    private var rating: Float = 2.5 { didSet { updateRatingStars() } }
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupRatingSlider()
        updateRatingStars()
        loadExistingData()
    }

    private func setupViews() {
        configureBookDetails()
        configureReviewInput()
        configureLayout()
    }

    private func configureBookDetails() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 3
        authorLabel.font = UIFont.systemFont(ofSize: 18)
        publishedDateLabel.font = UIFont.systemFont(ofSize: 18)
        thumbnailImageView.contentMode = .scaleAspectFit
        if let urlString = book?.displayThumbnail, let url = URL(string: urlString) {
            thumbnailImageView.sd_setImage(with: url,
                                           placeholderImage: UIImage(systemName: "book"),
                                           options: [.refreshCached])
        }
    }

    private func configureReviewInput() {
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        reviewTextView.layer.cornerRadius = 8
        reviewTextView.font = UIFont.systemFont(ofSize: 16)
    }

    private func configureLayout() {
        ratingView.axis = .horizontal
        ratingView.spacing = 8
        ratingView.alignment = .center
        ratingView.translatesAutoresizingMaskIntoConstraints = false

        ratingContainer.addSubview(ratingView)

        let infoStack = UIStackView(arrangedSubviews: [titleLabel, authorLabel, publishedDateLabel, thumbnailImageView])
        infoStack.axis = .vertical
        infoStack.spacing = 8
        let mainStack = UIStackView(arrangedSubviews: [infoStack, ratingContainer, reviewTextView, saveButton])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reviewTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            ratingView.centerXAnchor.constraint(equalTo: ratingContainer.centerXAnchor),
            ratingView.centerYAnchor.constraint(equalTo: ratingContainer.centerYAnchor)
        ])
    }

    private func updateRatingStars() {
        ratingView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let configuration = UIImage.SymbolConfiguration(paletteColors: [.yellow, .systemGray])
        let fullStar = UIImage(systemName: "star.fill", withConfiguration: configuration)
        let halfStar = UIImage(systemName: "star.lefthalf.fill", withConfiguration: configuration)
        let emptyStar = UIImage(systemName: "star", withConfiguration: configuration)

        let fullCount = Int(rating)
        let hasHalf = rating - Float(fullCount) >= 0.5

        for idx in 0..<5 {
            let imageView = UIImageView()
            imageView.contentMode = .center

            if idx < fullCount {
                imageView.image = fullStar
            } else if hasHalf && idx == fullCount {
                imageView.image = halfStar
            } else {
                imageView.image = emptyStar
            }

            ratingView.addArrangedSubview(imageView)
        }
    }

    private func setupRatingSlider() {
        ratingView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStarTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleStarTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: ratingView)
        let starWidth = ratingView.frame.width / 5
        let tappedStar = min(Int(location.x / starWidth), 4)
        let isHalf = location.x.truncatingRemainder(dividingBy: starWidth) < starWidth / 2

        rating = Float(tappedStar) + (isHalf ? 0.5 : 1.0)
    }

    private func loadExistingData() {
        titleLabel.text = book?.displayTitle
        authorLabel.text = book?.displayAuthor
        publishedDateLabel.text = book?.displayPublishedDate

        if let urlString = book?.displayThumbnail, let url = URL(string: urlString) {
            thumbnailImageView.sd_setImage(with: url,
                                           placeholderImage: UIImage(systemName: "book"),
                                           options: [.refreshCached])
        }
        reviewTextView.text = book?.displayReviewContent
        rating = book?.displayRating ?? 2.5
    }

    @objc private func saveButtonTapped() {
        let context = CoreDataManager.shared.context
        if let book = book as? Book {
            book.review?.content = reviewTextView.text
            book.review?.rating = rating
        } else if let bookAPI = book as? BookAPIResponse {
            let newBook = Book(context: context)
            newBook.id = UUID()
            newBook.title = bookAPI.volumeInfo.title
            newBook.author = bookAPI.volumeInfo.authors?.joined(separator: ", ")
            newBook.publishedDate = bookAPI.volumeInfo.publishedDate
            newBook.thumbnail = bookAPI.volumeInfo.imageLinks?.thumbnail
            newBook.createdAt = Date()

            let newReview = Review(context: context)
            newReview.id = UUID()
            newReview.content = reviewTextView.text
            newReview.rating = rating
            newReview.createdAt = Date()
            newReview.book = newBook
        }

        do {
            try context.save()
        } catch {
            os_log("Failed to save context: %{public}@", type: .error, error.localizedDescription)
        }

        navigationController?.popViewController(animated: true)
    }
}
