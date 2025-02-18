//
//  BookListCell.swift
//  BookLog
//
//  Created by 박지성 on 2/17/25.
//

import UIKit
import SDWebImage
import os

final class BookListCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private let publishedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        os_log("init(coder:) not implemented.", type: .error)
        return nil
    }

    private func setupViews() {
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(authorLabel)
        textStackView.addArrangedSubview(publishedDateLabel)

        let containerStackView = UIStackView(arrangedSubviews: [textStackView, thumbnailImageView])
        containerStackView.axis = .horizontal
        containerStackView.spacing = 8
        containerStackView.alignment = .center
        containerStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    func configure(with book: BookDisplayable) {
        titleLabel.text = book.displayTitle
        authorLabel.text = book.displayAuthor
        publishedDateLabel.text = book.displayPublishedDate
        if let urlString = book.displayThumbnail, let url = URL(string: urlString) {
            thumbnailImageView.sd_setImage(with: url,
                                           placeholderImage: UIImage(systemName: "책 표지"),
                                           options: [.refreshCached])
        }
    }
}
