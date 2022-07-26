//
//  FavoriteFoods+CoreDataProperties.swift
//  DangProject
//
//  Created by 김성원 on 2022/07/26.
//
//

import Foundation
import CoreData


extension FavoriteFoods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteFoods> {
        return NSFetchRequest<FavoriteFoods>(entityName: "FavoriteFoods")
    }

    @NSManaged public var foodCode: String?
    @NSManaged public var name: String?
    @NSManaged public var sugar: String?

}

extension FavoriteFoods : Identifiable {

}
