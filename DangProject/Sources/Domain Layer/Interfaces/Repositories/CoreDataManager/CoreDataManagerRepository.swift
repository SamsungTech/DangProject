//
//  CoreDataManagerRepository.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation
import CoreData

protocol CoreDataManagerRepository {
   
    func addFoods(_ food: FoodDomainModel, at coreDataName: CoreDataName)
    func addRecentQuery(_ keyWord: String)
    func loadFromCoreData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]
    @discardableResult func deleteFavoriteFood<T: NSManagedObject>(at code: String, request: NSFetchRequest<T>) -> Bool
    @discardableResult func deleteQuery<T: NSManagedObject>(at query: String, request: NSFetchRequest<T>) -> Bool
    @discardableResult func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool
    
    func createAlarmEntity(_ alarm: AlarmDomainModel)
    func readTotalAlarmEntity() -> [AlarmDomainModel]
    func updateAlarmEntity(_ alarm: AlarmDomainModel)
    func deleteAlarmEntity(_ alarm: AlarmDomainModel)
}
