//
//  GraphYear+CoreDataProperties.swift
//  DangProject
//
//  Created by 김동우 on 2022/08/09.
//
//

import Foundation
import CoreData


extension GraphYear {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GraphYear> {
        return NSFetchRequest<GraphYear>(entityName: "GraphYear")
    }

    @NSManaged public var year: Int32
    @NSManaged public var dangAverage: Int32
    @NSManaged public var month: NSSet?

}

// MARK: Generated accessors for month
extension GraphYear {

    @objc(addMonthObject:)
    @NSManaged public func addToMonth(_ value: GraphMonth)

    @objc(removeMonthObject:)
    @NSManaged public func removeFromMonth(_ value: GraphMonth)

    @objc(addMonth:)
    @NSManaged public func addToMonth(_ values: NSSet)

    @objc(removeMonth:)
    @NSManaged public func removeFromMonth(_ values: NSSet)

}
