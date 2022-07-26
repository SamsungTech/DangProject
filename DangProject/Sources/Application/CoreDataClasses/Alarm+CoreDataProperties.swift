//
//  Alarm+CoreDataProperties.swift
//  DangProject
//
//  Created by 김성원 on 2022/07/26.
//
//

import Foundation
import CoreData


extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var isOn: Bool
    @NSManaged public var message: String?
    @NSManaged public var selectedDays: [Int]?
    @NSManaged public var time: Date?
    @NSManaged public var title: String?

}

extension Alarm : Identifiable {

}
