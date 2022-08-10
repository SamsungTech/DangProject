//
//  AllGraph+CoreDataProperties.swift
//  DangProject
//
//  Created by 김동우 on 2022/08/09.
//
//

import Foundation
import CoreData


extension AllGraph {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllGraph> {
        return NSFetchRequest<AllGraph>(entityName: "AllGraph")
    }

    @NSManaged public var year: NSSet?
    @NSManaged public var month: NSSet?
    @NSManaged public var day: NSSet?
    
    public var graphYearArray: [GraphYear] {
        let graphSet = year as? Set<GraphYear> ?? []
        return graphSet.sorted {
            $0.unwrappedTag < $1.unwrappedTag
        }
    }
    
    public var graphMonthArray: [GraphMonth] {
        let graphSet = month as? Set<GraphMonth> ?? []
        return graphSet.sorted {
            $0.unwrappedTag < $1.unwrappedTag
        }
    }
    
    public var graphDayArray: [GraphDay] {
        let graphSet = day as? Set<GraphDay> ?? []
        return graphSet.sorted {
            $0.unwrappedTag < $1.unwrappedTag
        }
    }

}

// MARK: Generated accessors for year
extension AllGraph {

    @objc(addYearObject:)
    @NSManaged public func addToYear(_ value: GraphYear)

    @objc(removeYearObject:)
    @NSManaged public func removeFromYear(_ value: GraphYear)

    @objc(addYear:)
    @NSManaged public func addToYear(_ values: NSSet)

    @objc(removeYear:)
    @NSManaged public func removeFromYear(_ values: NSSet)

}

// MARK: Generated accessors for month
extension AllGraph {

    @objc(addMonthObject:)
    @NSManaged public func addToMonth(_ value: GraphMonth)

    @objc(removeMonthObject:)
    @NSManaged public func removeFromMonth(_ value: GraphMonth)

    @objc(addMonth:)
    @NSManaged public func addToMonth(_ values: NSSet)

    @objc(removeMonth:)
    @NSManaged public func removeFromMonth(_ values: NSSet)

}

// MARK: Generated accessors for day
extension AllGraph {

    @objc(addDayObject:)
    @NSManaged public func addToDay(_ value: GraphDay)

    @objc(removeDayObject:)
    @NSManaged public func removeFromDay(_ value: GraphDay)

    @objc(addDay:)
    @NSManaged public func addToDay(_ values: NSSet)

    @objc(removeDay:)
    @NSManaged public func removeFromDay(_ values: NSSet)

}
