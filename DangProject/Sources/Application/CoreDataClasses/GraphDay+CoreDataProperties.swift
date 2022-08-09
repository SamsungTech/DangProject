//
//  GraphDay+CoreDataProperties.swift
//  DangProject
//
//  Created by 김동우 on 2022/08/09.
//
//

import Foundation
import CoreData


extension GraphDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GraphDay> {
        return NSFetchRequest<GraphDay>(entityName: "GraphDay")
    }

    @NSManaged public var dangAverage: Int32
    @NSManaged public var day: Int32
    @NSManaged public var month: GraphMonth?

}
