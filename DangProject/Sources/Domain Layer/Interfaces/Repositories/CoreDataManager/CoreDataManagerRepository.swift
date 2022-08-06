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
    func addRecentQuery(keyword: String)
    func createEatenFoodPerDay(date: Date)
    func fetchEatenFoodsPerDay(date: Date) -> EatenFoodsPerDay
    func fetchCoreDataArray(from: CoreDataName) -> [NSManagedObject]
    func deleteFavoriteFood(code: String)
    func deleteQuery(at query: String)
    func deleteAll(coreDataName: CoreDataName)
    func deleteEatenFoodsPerDay(date: Date)
    func checkEatenFoodsPerDay(date: Date) -> Observable<(Bool, EatenFoodsPerDay)>
    func updateCoreDataEatenFoodsPerDay(data: EatenFoodsPerDayDomainModel,
                                      date: Date)
    func updateLocal(data: EatenFoodsPerDayDomainModel,
                     date: Date)
    func createAlarmEntity(_ alarm: AlarmDomainModel)
    func readTotalAlarmEntity() -> [AlarmDomainModel]
    func updateAlarmEntity(_ alarm: AlarmDomainModel)
    func deleteAlarmEntity(_ alarm: AlarmDomainModel)

}

