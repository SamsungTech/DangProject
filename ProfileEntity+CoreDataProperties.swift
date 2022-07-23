//
//  ProfileEntity+CoreDataProperties.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/22.
//
//

import Foundation
import CoreData


extension ProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileEntity> {
        return NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
    }

    @NSManaged public var birthDay: String?
    @NSManaged public var gender: String?
    @NSManaged public var height: Int32
    @NSManaged public var weight: Int32
    @NSManaged public var name: String?
    @NSManaged public var sugarLevel: Int32

}

extension ProfileEntity : Identifiable {

}
