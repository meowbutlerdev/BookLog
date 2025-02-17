//
//  BookListCell.swift
//  BookLog
//
//  Created by 박지성 on 2/17/25.
//

import UIKit
import SDWebImage

final class BookListCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let publishedDateLabel = UILabel()
    private let thumbnailImageView = UIImageView()

    private let textStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        authorLabel.font = UIFont.systemFont(ofSize: 15)
        publishedDateLabel.font = UIFont.systemFont(ofSize: 12)

        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(authorLabel)
        textStackView.addArrangedSubview(publishedDateLabel)

        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        let containerStackView = UIStackView(arrangedSubviews: [textStackView, thumbnailImageView])
        containerStackView.axis = .horizontal
        containerStackView.spacing = 8
        containerStackView.alignment = .center

        contentView.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with bookResponse: BookAPIResponse) {
        titleLabel.text = bookResponse.volumeInfo.title
        authorLabel.text = bookResponse.volumeInfo.authors?.joined(separator: ", ") ?? "저자 없음"
        publishedDateLabel.text = bookResponse.volumeInfo.publishedDate ?? "출판일 없음"
        if let url = URL(string: bookResponse.volumeInfo.imageLinks?.thumbnail ?? "") {
            thumbnailImageView.loadImage(from: url)
        }
    }

    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.author ?? "저자 없음"
        publishedDateLabel.text = book.publishedDate ?? "출판일 없음"
        if let url = URL(string: book.thumbnail ?? "") {
            thumbnailImageView.loadImage(from: url)
        }
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        self.sd_setImage(with: url, placeholderImage: UIImage(systemName: "책 이미지"), options: .refreshCached)
    }
}
