//
//  ProfileEntity+CoreDataProperties.swift
//  DangProject
//
//  Created by 김동우 on 2022/08/06.
//
//

import Foundation
import CoreData


extension ProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileEntity> {
        return NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
    }

    @NSManaged public var birthday: String?
    @NSManaged public var gender: String?
    @NSManaged public var height: Int32
    @NSManaged public var name: String?
    @NSManaged public var profileImage: Data?
    @NSManaged public var sugarLevel: Int32
    @NSManaged public var weight: Int32
}

extension ProfileEntity : Identifiable {
}
