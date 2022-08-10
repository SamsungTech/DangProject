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

    @NSManaged public var dangAverage: String?
    @NSManaged public var tag: Int32
    @NSManaged public var graph: AllGraph?
    
    public var unwrappedTag: Int32 {
        tag
    }
}
