//
//  RecentQuery+CoreDataProperties.swift
//  
//
//  Created by 김성원 on 2022/02/22.
//
//

import Foundation
import CoreData


extension RecentQuery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentQuery> {
        return NSFetchRequest<RecentQuery>(entityName: "RecentQuery")
    }

    @NSManaged public var keyWord: String?

}
