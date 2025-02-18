//
//  Review+CoreDataProperties.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var id: UUID
    @NSManaged public var rating: Float
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var book: Book?

}

extension Review : Identifiable {

}
