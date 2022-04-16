//
//  EatenFoods+CoreDataProperties.swift
//  
//
//  Created by 김성원 on 2022/03/12.
//
//

import Foundation
import CoreData


extension EatenFoods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EatenFoods> {
        return NSFetchRequest<EatenFoods>(entityName: "EatenFoods")
    }

    @NSManaged public var amount: Double
    @NSManaged public var foodCode: String?
    @NSManaged public var name: String?
    @NSManaged public var sugar: Double

}
