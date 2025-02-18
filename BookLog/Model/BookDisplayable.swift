//
//  BookDisplayable.swift
//  BookLog
//
//  Created by 박지성 on 2/18/25.
//

import Foundation

protocol BookDisplayable {
    var displayID: String { get }
    var displayTitle: String { get }
    var displayAuthor: String? { get }
    var displayThumbnail: String? { get }
    var displayPublishedDate: String? { get }
    var displayCategories: String? { get }
    var displayRating: Float? { get }
    var displayReviewContent: String? { get }
}

extension Book: BookDisplayable {
    var displayID: String { self.id.uuidString }
    var displayTitle: String { self.title }
    var displayAuthor: String? { self.author }
    var displayThumbnail: String? { self.thumbnail }
    var displayPublishedDate: String? { self.publishedDate }
    var displayCategories: String? { self.categories }
    var displayRating: Float? { self.review?.rating }
    var displayReviewContent: String? { self.review?.content }
}

extension BookAPIResponse: BookDisplayable {
    var displayID: String { self.id }
    var displayTitle: String { self.volumeInfo.title }
    var displayAuthor: String? { self.volumeInfo.authors?.joined(separator: ", ") }
    var displayThumbnail: String? { self.volumeInfo.imageLinks?.thumbnail }
    var displayPublishedDate: String? { self.volumeInfo.publishedDate }
    var displayCategories: String? { self.volumeInfo.categories?.joined(separator: ", ") }
    var displayRating: Float? { nil }
    var displayReviewContent: String? { nil }
}
