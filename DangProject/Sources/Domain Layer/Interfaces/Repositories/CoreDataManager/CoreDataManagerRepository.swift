//
//  CoreDataManagerRepository.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation
import CoreData

import RxSwift

protocol CoreDataManagerRepository {
    
    func addFavoriteFood(food: FoodDomainModel)
    func addEatenFood(food: FoodDomainModel,
                      eatenFoodsPerDayEntity: EatenFoodsPerDay?)
    func addRecentQuery(keyword: String)
    func loadFromCoreData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]
    @discardableResult func deleteFavoriteFood<T: NSManagedObject>(at code: String, request: NSFetchRequest<T>) -> Bool
    @discardableResult func deleteQuery<T: NSManagedObject>(at query: String, request: NSFetchRequest<T>) -> Bool
    @discardableResult func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool
    func checkEatenFoodsPerDay<T: NSManagedObject>(request: NSFetchRequest<T>) -> Observable<(Bool, T)>
}
