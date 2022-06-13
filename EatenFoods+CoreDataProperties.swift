//
//  EatenFoods+CoreDataProperties.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/14.
//
//

import Foundation
import CoreData


extension EatenFoods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EatenFoods> {
        return NSFetchRequest<EatenFoods>(entityName: "EatenFoods")
    }

    @NSManaged public var amount: Double
    @NSManaged public var eatenTime: Date?
    @NSManaged public var foodCode: String?
    @NSManaged public var name: String?
    @NSManaged public var sugar: Double
    @NSManaged public var day: EatenFoodsPerDay?

    public var wrappedEatenTime: Date {
            eatenTime ?? Date.init()
        }
    
}

extension EatenFoods : Identifiable {

}
