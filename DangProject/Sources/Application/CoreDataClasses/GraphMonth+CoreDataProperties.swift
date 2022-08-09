//
//  GraphMonth+CoreDataProperties.swift
//  DangProject
//
//  Created by 김동우 on 2022/08/09.
//
//

import Foundation
import CoreData


extension GraphMonth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GraphMonth> {
        return NSFetchRequest<GraphMonth>(entityName: "GraphMonth")
    }

    @NSManaged public var month: Int32
    @NSManaged public var dangAverage: Int32
    @NSManaged public var year: GraphYear?
    @NSManaged public var day: NSSet?

}

// MARK: Generated accessors for day
extension GraphMonth {

    @objc(addDayObject:)
    @NSManaged public func addToDay(_ value: GraphDay)

    @objc(removeDayObject:)
    @NSManaged public func removeFromDay(_ value: GraphDay)

    @objc(addDay:)
    @NSManaged public func addToDay(_ values: NSSet)

    @objc(removeDay:)
    @NSManaged public func removeFromDay(_ values: NSSet)

}
