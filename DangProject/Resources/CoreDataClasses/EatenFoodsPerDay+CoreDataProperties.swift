//
//  EatenFoodsPerDay+CoreDataProperties.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/12.
//
//

import Foundation
import CoreData


extension EatenFoodsPerDay {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EatenFoodsPerDay> {
        return NSFetchRequest<EatenFoodsPerDay>(entityName: "EatenFoodsPerDay")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var eatenFoods: NSSet?
    
    public var eatenFoodsArray: [EatenFoods] {
        let eatenFoodSet = eatenFoods as? Set<EatenFoods> ?? []
        return eatenFoodSet.sorted {
            $0.unwrappedEatenTime < $1.unwrappedEatenTime
        }
    }
}

// MARK: Generated accessors for eatenFoods
extension EatenFoodsPerDay {
    
    @objc(addEatenFoodsObject:)
    @NSManaged public func addToEatenFoods(_ value: EatenFoods)
    
    @objc(removeEatenFoodsObject:)
    @NSManaged public func removeFromEatenFoods(_ value: EatenFoods)
    
    @objc(addEatenFoods:)
    @NSManaged public func addToEatenFoods(_ values: NSSet)
    
    @objc(removeEatenFoods:)
    @NSManaged public func removeFromEatenFoods(_ values: NSSet)
    
}

extension EatenFoodsPerDay : Identifiable {
    
}
