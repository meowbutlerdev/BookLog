//
//  GoogleBooksResponse.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//

import Foundation

struct GoogleBooksResponse: Decodable {
    let items: [BookAPIResponse]
}

struct BookAPIResponse: Decodable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let description: String?
    let categories: [String]?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Decodable {
    let thumbnail: String?
}
