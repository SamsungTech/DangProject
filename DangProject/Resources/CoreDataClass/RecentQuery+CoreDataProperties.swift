//
//  RecentQuery+CoreDataProperties.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/13.
//
//

import Foundation
import CoreData


extension RecentQuery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentQuery> {
        return NSFetchRequest<RecentQuery>(entityName: "RecentQuery")
    }

    @NSManaged public var keyword: String?

}

extension RecentQuery : Identifiable {

}
