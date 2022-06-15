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
    func fetchCoreDataArray(from: CoreDataName) -> [NSManagedObject]
    func deleteFavoriteFood(code: String)
    func deleteQuery(at query: String)
    func deleteAll(coreDataName: CoreDataName)
    func checkEatenFoodsPerDay(date: Date) -> Observable<(Bool, EatenFoodsPerDay)>
}
