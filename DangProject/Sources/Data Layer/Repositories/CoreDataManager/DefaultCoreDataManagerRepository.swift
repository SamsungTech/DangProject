//
//  CoreDataManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/14.
//

import UIKit
import CoreData

import RxSwift

enum CoreDataName: String {
    case favoriteFoods = "FavoriteFoods"
    case recentQuery = "RecentQuery"
    case eatenFoods = "EatenFoods"
    case eatenFoodsPerDay = "EatenFoodsPerDay"
}

class DefaultCoreDataManagerRepository: CoreDataManagerRepository {
    
    private let disposeBag = DisposeBag()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    
    func checkEatenFoodsPerDay<T: NSManagedObject>(request: NSFetchRequest<T>) -> Observable<(Bool, T)> {
        return Observable.create { [weak self] emitter in
            
            let today = Date.currentDate()
            request.predicate = NSPredicate(format: "date == %@", today as CVarArg)
            
            do {
                if let checkedEatenFoodsPerDay = try self?.context?.fetch(request) {
                    if checkedEatenFoodsPerDay.count == 0 {
                        emitter.onNext((true, T.init()))
                    } else {
                        emitter.onNext((false, checkedEatenFoodsPerDay[0]))
                    }
                }
            } catch {
                print(error.localizedDescription)
                return Disposables.create()
            }
            
            return Disposables.create()
        }
    }
    
    func addFavoriteFood(food: FoodDomainModel) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.favoriteFoods.rawValue, in: context),
              let favoriteFoods = NSManagedObject(entity: entity, insertInto: context) as? FavoriteFoods else { return }
        favoriteFoods.name = food.name
        favoriteFoods.sugar = food.sugar
        favoriteFoods.foodCode = food.foodCode
        
        do {
            try context.save ()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addEatenFood(food: FoodDomainModel,
                      eatenFoodsPerDayEntity: EatenFoodsPerDay?) {
        
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.eatenFoodsPerDay.rawValue, in: context) else { return }
        if eatenFoodsPerDayEntity == nil {
            guard let eatenFoodsPerDay = NSManagedObject(entity: entity, insertInto: context) as? EatenFoodsPerDay else { return }
            eatenFoodsPerDay.date = Date.currentDate()
            updateEatenFood(food: food, parentEatenFoodsPerDay: eatenFoodsPerDay)
        } else {
            guard let unwrappedEatenFoodsPerDayEntity = eatenFoodsPerDayEntity else { return }
            updateEatenFoodsPerDay(eatenFood: food, to: unwrappedEatenFoodsPerDayEntity)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func addRecentQuery(keyword: String) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.recentQuery.rawValue, in: context) else { return }
        guard let recentQuery = NSManagedObject(entity: entity, insertInto: context) as? RecentQuery else { return }
        recentQuery.keyword = keyword
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadFromCoreData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        guard let context = self.context else { return [] }
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func loadTodayEatenFoods(eatenFoodsPerDayEntity: EatenFoodsPerDay) -> [EatenFoods] {
        return eatenFoodsPerDayEntity.eatenFoodsArray
    }
    
    @discardableResult
    func deleteFavoriteFood<T: NSManagedObject>(at code: String, request: NSFetchRequest<T>) -> Bool {
        
        request.predicate = NSPredicate(format: "foodCode == %@", code)
        
        do {
            if let favoriteFoods = try context?.fetch(request) {
                if favoriteFoods.count == 0 { return false }
                context?.delete(favoriteFoods[0])
                try context?.save()
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    @discardableResult
    func deleteQuery<T: NSManagedObject>(at query: String, request: NSFetchRequest<T>) -> Bool {
        
        request.predicate = NSPredicate(format: "keyword == %@", query)
        
        do {
            if let recentQuery = try context?.fetch(request) {
                if recentQuery.count == 0 { return false }
                context?.delete(recentQuery[0])
                try context?.save()
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context?.execute(delete)
            return true
        } catch {
            return false
        }
    }
    
    func updateEatenFood(food: FoodDomainModel,
                              parentEatenFoodsPerDay: EatenFoodsPerDay) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.eatenFoods.rawValue,
                                                      in: context),
              let eatenFoods = NSManagedObject(entity: entity, insertInto: context) as? EatenFoods
        else { return }
        eatenFoods.day = parentEatenFoodsPerDay
        eatenFoods.name = food.name
        eatenFoods.sugar = Double(food.sugar) ?? 0
        eatenFoods.foodCode = food.foodCode
        eatenFoods.amount = Double(food.amount)
        eatenFoods.eatenTime = Date.currentTime()
    }
    
    private func updateEatenFoodsPerDay(eatenFood: FoodDomainModel,
                                        to eatenFoodsPerDay: EatenFoodsPerDay) {
        let request = EatenFoods.fetchRequest()
        request.predicate = NSPredicate(format: "foodCode == %@", eatenFood.foodCode)
        
        do {
            if let eatenFoods = try context?.fetch(request) {
                if eatenFoods.count != 0 {
                    context?.delete(eatenFoods[0])
                }
                updateEatenFood(food: eatenFood, parentEatenFoodsPerDay: eatenFoodsPerDay)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

