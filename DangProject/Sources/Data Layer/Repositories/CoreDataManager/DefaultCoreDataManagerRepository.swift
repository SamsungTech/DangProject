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
    
    func checkEatenFoodsPerDay(date: Date) -> Observable<(Bool, EatenFoodsPerDay)> {
        return Observable.create { [weak self] emitter in
            
            guard let request = self?.getRequest(coreDataName: .eatenFoodsPerDay) else { return Disposables.create() }
            
            request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
            
            do {
                if let checkedEatenFoodsPerDay = try self?.context?.fetch(request) {
                    if checkedEatenFoodsPerDay.count == 0 {
                        emitter.onNext((true, EatenFoodsPerDay.init()))
                    } else {
                        emitter.onNext((false, checkedEatenFoodsPerDay[0] as! EatenFoodsPerDay))
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
            updateEatenFoodsPerDay(eatenFood: food, to: eatenFoodsPerDay)
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
    
    func fetchCoreDataArray(from coreDataName: CoreDataName) -> [NSManagedObject] {
        switch coreDataName {
        case .favoriteFoods:
            return loadArrayFromCoreData(request: FavoriteFoods.fetchRequest())
        case .recentQuery:
            return loadArrayFromCoreData(request: RecentQuery.fetchRequest())
        case .eatenFoods:
            return loadArrayFromCoreData(request: EatenFoods.fetchRequest())
        case .eatenFoodsPerDay:
            return loadArrayFromCoreData(request: EatenFoodsPerDay.fetchRequest())
        }
    }

    func deleteFavoriteFood(code: String) {
        let request = self.getRequest(coreDataName: .favoriteFoods)
        
        request.predicate = NSPredicate(format: "foodCode == %@", code)
        
        do {
            if let favoriteFoods = try context?.fetch(request) {
                if favoriteFoods.count == 0 { return  }
                context?.delete(favoriteFoods[0] as! FavoriteFoods)
                try context?.save()
                return
            }
        } catch {
            print(error.localizedDescription)
            return
        }
        
        return
    }
    
    func deleteQuery(at query: String) {
        let request = self.getRequest(coreDataName: .recentQuery)
        request.predicate = NSPredicate(format: "keyword == %@", query)
        
        do {
            if let recentQuery = try context?.fetch(request) {
                if recentQuery.count == 0 { return }
                context?.delete(recentQuery[0] as! RecentQuery)
                try context?.save()
                return
            }
        } catch {
            print(error.localizedDescription)
            return
        }
        return
    }
    
    func deleteAll(coreDataName: CoreDataName) {
        let request = self.getRequest(coreDataName: coreDataName)
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context?.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Private
        
    private func getRequest(coreDataName: CoreDataName) -> NSFetchRequest<NSFetchRequestResult> {
        switch coreDataName {
        case .eatenFoods:
            return EatenFoods.fetchRequest()
        case .eatenFoodsPerDay:
            return EatenFoodsPerDay.fetchRequest()
        case .favoriteFoods:
            return FavoriteFoods.fetchRequest()
        case .recentQuery:
            return RecentQuery.fetchRequest()
        }
    }
    
    private func updateEatenFood(food: FoodDomainModel,
                         parentEatenFoodsPerDay: EatenFoodsPerDay,
                                 eatenTime: Date?) {
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
        if eatenTime == nil {
            eatenFoods.eatenTime = Date.currentTime()
        } else {
            eatenFoods.eatenTime = eatenTime
        }
    }
    
    private func updateEatenFoodsPerDay(eatenFood: FoodDomainModel,
                                        to eatenFoodsPerDay: EatenFoodsPerDay) {
        let request = EatenFoods.fetchRequest()
        request.predicate = NSPredicate(format: "foodCode == %@", eatenFood.foodCode)
        
        do {
            if let eatenFoods = try context?.fetch(request) {
                if eatenFoods.count != 0 {
                    let eatenTime = eatenFoods[0].unwrappedEatenTime
                    context?.delete(eatenFoods[0])
                    updateEatenFood(food: eatenFood,
                                    parentEatenFoodsPerDay: eatenFoodsPerDay,
                                    eatenTime: eatenTime)
                } else {
                    updateEatenFood(food: eatenFood,
                                    parentEatenFoodsPerDay: eatenFoodsPerDay,
                                    eatenTime: nil)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadArrayFromCoreData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
           guard let context = self.context else { return [] }
           do {
               let results = try context.fetch(request)
               return results
           } catch {
               print(error.localizedDescription)
               return []
           }
       }
}

