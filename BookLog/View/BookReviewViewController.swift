//
//  BookReviewViewController.swift
//  BookLog
//
//  Created by 박지성 on 2/17/25.
//

import UIKit

final class BookReviewViewController: UIViewController {
    var book: BookAPIResponse?
    var existingBook: Book?

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let publishedDateLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    private let reviewTextView = UITextView()
    private let ratingView = UIStackView()
    private var rating: Float = 2.5 { didSet { updateRatingStars() } }
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupRatingSlider()
        updateRatingStars()
        loadExistingData()
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

        let ratingContainer = UIView()
        ratingView.axis = .horizontal
        ratingView.spacing = 8
        ratingView.alignment = .center
        ratingContainer.addSubview(ratingView)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingView.centerXAnchor.constraint(equalTo: ratingContainer.centerXAnchor),
            ratingView.centerYAnchor.constraint(equalTo: ratingContainer.centerYAnchor)
        ])

        saveButton.setTitle("저장", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        let infoStackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel,
                                                           publishedDateLabel, thumbnailImageView])
        infoStackView.axis = .vertical
        infoStackView.spacing = 8

        let mainStackView = UIStackView(arrangedSubviews: [infoStackView, ratingContainer,
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

    private func loadExistingData() {
        if let existingBook = existingBook {
            titleLabel.text = existingBook.title
            authorLabel.text = existingBook.author
            publishedDateLabel.text = existingBook.publishedDate
            if let url = URL(string: existingBook.thumbnail ?? "") {
                thumbnailImageView.sd_setImage(with: url)
            }
            reviewTextView.text = existingBook.review?.content
            rating = existingBook.review?.rating ?? 2.5
        }
    }

    @objc private func saveButtonTapped() {
        let context = CoreDataManager.shared.context
        if let existingBook = existingBook {
            existingBook.review?.content = reviewTextView.text
            existingBook.review?.rating = rating
        } else if let book = book {
            let newBook = Book(context: context)
            newBook.id = UUID()
            newBook.title = book.volumeInfo.title
            newBook.author = book.volumeInfo.authors?.joined(separator: ", ")
            newBook.publishedDate = book.volumeInfo.publishedDate
            newBook.thumbnail = book.volumeInfo.imageLinks?.thumbnail
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
            print("Failed to save context: \(error)")
        }

        navigationController?.popViewController(animated: true)
    }
}
