//
//  RatingEntity+CoreDataProperties.swift
//  TV Shows
//
//  Created by Harikrishnan S R on 22/09/21.
//
//

import Foundation
import CoreData


extension RatingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RatingEntity> {
        return NSFetchRequest<RatingEntity>(entityName: "RatingEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var rating: Double

}

extension RatingEntity : Identifiable {

}
