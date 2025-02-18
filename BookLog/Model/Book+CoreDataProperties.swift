//
//  Book+CoreDataProperties.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var author: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var publishedDate: String?
    @NSManaged public var categories: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var review: Review?

}

// MARK: Generated accessors for reviews
extension Book {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}

extension Book : Identifiable {

}
