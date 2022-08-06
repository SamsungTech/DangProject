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
    case alarm = "Alarm"
}

class DefaultCoreDataManagerRepository: CoreDataManagerRepository {
    
    private let disposeBag = DisposeBag()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    func checkEatenFoodsPerDay(date: Date) -> Observable<(Bool, EatenFoodsPerDay)> {
        return Observable.create { [weak self] emitter in
            
            let request = EatenFoodsPerDay.fetchRequest()
            
            request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
            
            do {
                if let checkedEatenFoodsPerDay = try self?.context?.fetch(request) {
                    if checkedEatenFoodsPerDay.count == 0 {
                        emitter.onNext((true, EatenFoodsPerDay.init()))
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
    
    func fetchEatenFoodsPerDay(date: Date) -> EatenFoodsPerDay {
        let request = EatenFoodsPerDay.fetchRequest()
        
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        
        do {
            if let checkedEatenFoodsPerDay = try self.context?.fetch(request) {
                if checkedEatenFoodsPerDay.count == 0 {
                    return EatenFoodsPerDay.init()
                } else {
                    return checkedEatenFoodsPerDay[0]
                }
            }
        } catch {
            print(error.localizedDescription)
            return EatenFoodsPerDay.init()
        }
        
        return EatenFoodsPerDay.init()
    }
    
    func addFavoriteFood(food: FoodDomainModel) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.favoriteFoods.rawValue, in: context),
              let favoriteFoods = NSManagedObject(entity: entity, insertInto: context) as? FavoriteFoods else { return }
        favoriteFoods.name = food.name
        favoriteFoods.sugar = String(food.sugar)
        favoriteFoods.foodCode = food.foodCode
        
        do {
            try context.save ()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createEatenFoodPerDay(date: Date) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.eatenFoodsPerDay.rawValue, in: context) else { return }
        guard let eatenFoodsPerDay = NSManagedObject(entity: entity, insertInto: context) as? EatenFoodsPerDay else { return }
        eatenFoodsPerDay.date = date
        
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
    
    func updateLocal(data: EatenFoodsPerDayDomainModel,
                     date: Date) {
        deleteEatenFoodsPerDay(date: date)
        createEatenFoodPerDay(date: date)
        data.eatenFoods.forEach { food in
        let eatenFoodsPerDay = self.fetchEatenFoodsPerDay(date: date)
            updateEatenFood(food: food, parentEatenFoodsPerDay: eatenFoodsPerDay, eatenTime: food.eatenTime.dateValue())
        }
    }
    
    func updateCoreDataEatenFoodsPerDay(data: EatenFoodsPerDayDomainModel,
                                        date: Date) {
        let request = EatenFoodsPerDay.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        do {
            if let checkedEatenFoodsPerDay = try context?.fetch(request) {
                if checkedEatenFoodsPerDay.count == 0 {
                } else {
                    
                }
            }
        } catch {
            print(error.localizedDescription)
            return
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
        case .alarm:
            return loadArrayFromCoreData(request: Alarm.fetchRequest())
        }
    }
    
    func deleteEatenFoodsPerDay(date: Date) {
        let request = EatenFoodsPerDay.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        do {
            if let checkedEatenFoodsPerDay = try context?.fetch(request) {
                if checkedEatenFoodsPerDay.count == 0 {
                    return
                } else {
                    context?.delete(checkedEatenFoodsPerDay[0])
                    try context?.save()
                    return
                }
            }
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func deleteFavoriteFood(code: String) {
        let request = self.getRequest(coreDataName: .favoriteFoods)
        
        request.predicate = NSPredicate(format: "foodCode == %@", code)
        
        do {
            if let favoriteFoods = try context?.fetch(request) {
                if favoriteFoods.count == 0 { return }
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
        case .alarm:
            return Alarm.fetchRequest()
        }
    }
    
    private func updateEatenFood(food: FoodDomainModel,
                                 parentEatenFoodsPerDay: EatenFoodsPerDay,
                                 eatenTime: Date) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.eatenFoods.rawValue,
                                                      in: context),
              let eatenFoods = NSManagedObject(entity: entity, insertInto: context) as? EatenFoods
        else { return }
        eatenFoods.day = parentEatenFoodsPerDay
        eatenFoods.name = food.name
        eatenFoods.sugar = food.sugar
        eatenFoods.foodCode = food.foodCode
        eatenFoods.amount = Double(food.amount)
        eatenFoods.eatenTime = eatenTime
        
        do {
            try context.save()
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
    
    func createAlarmEntity(_ alarm: AlarmDomainModel) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.alarm.rawValue, in: context),
              let alarmEntity = NSManagedObject(entity: entity, insertInto: context) as? Alarm else { return }
        alarmEntity.isOn = alarm.isOn
        alarmEntity.title = alarm.title
        alarmEntity.message = alarm.message
        alarmEntity.time = alarm.time
        alarmEntity.identifier = alarm.identifier
        alarmEntity.selectedDays = alarm.selectedDaysOfTheWeek.map{ $0.rawValue }
        
        do {
            try context.save ()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readTotalAlarmEntity() -> [AlarmDomainModel] {
        let result = loadArrayFromCoreData(request: Alarm.fetchRequest())
        let alarmDomainModelArray = result.map{ AlarmDomainModel.init(alarmEntity: $0) }
        return alarmDomainModelArray.sorted { $0.time < $1.time }
    }
    
    func updateAlarmEntity(_ alarm: AlarmDomainModel) {
        let request = Alarm.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", alarm.identifier)
        do {
            if let checkedAlarmEntity = try context?.fetch(request),
               checkedAlarmEntity.count != 0 {
                checkedAlarmEntity[0].isOn = alarm.isOn
                checkedAlarmEntity[0].title = alarm.title
                checkedAlarmEntity[0].message = alarm.message
                checkedAlarmEntity[0].time = alarm.time
                checkedAlarmEntity[0].selectedDays = alarm.selectedDaysOfTheWeek.map{ $0.rawValue }
                try context?.save()
                return
            }
        } catch {
            print(error.localizedDescription)
            return
        }
    }

    func deleteAlarmEntity(_ alarm: AlarmDomainModel) {
        let request = Alarm.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", alarm.identifier)
        do {
            if let checkedAlarmEntity = try context?.fetch(request),
               checkedAlarmEntity.count != 0{
                context?.delete(checkedAlarmEntity[0])
                try context?.save()
                return
            }
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}
