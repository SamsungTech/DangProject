//
//  FavoriteFoods+CoreDataProperties.swift
//  
//
//  Created by 김성원 on 2022/02/14.
//
//

import Foundation
import CoreData


extension FavoriteFoods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteFoods> {
        return NSFetchRequest<FavoriteFoods>(entityName: "FavoriteFoods")
    }

    @NSManaged public var foodCode: String?

}
