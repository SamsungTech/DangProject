//
//  CoreDataManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/14.
//

import UIKit
import CoreData

enum CoreDataName: String {
    case favoriteFoods = "FavoriteFoods"
    case eatenFoods = "EatenFoods"
    case alarm = "Alarm"
}

class DefaultCoreDataManagerRepository: CoreDataManagerRepository {
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext

    func addFoods(_ food: FoodDomainModel, at coreDataName: CoreDataName) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: coreDataName.rawValue, in: context) else { return }
        switch coreDataName {
        case .favoriteFoods:
            guard let favoriteFoods = NSManagedObject(entity: entity, insertInto: context) as? FavoriteFoods else { return }
            favoriteFoods.name = food.name
            favoriteFoods.sugar = food.sugar
            favoriteFoods.foodCode = food.foodCode
        case .eatenFoods:
            guard let eatenFoods = NSManagedObject(entity: entity, insertInto: context) as? EatenFoods else { return }
            eatenFoods.name = food.name
            eatenFoods.sugar = Double(food.sugar) ?? 0
            eatenFoods.foodCode = food.foodCode
            eatenFoods.amount = Double(food.amount)
        case .alarm:
            break
        }
        do {
            try context.save ()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addRecentQuery(_ keyword: String) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: "RecentQuery", in: context) else { return }
        guard let recentQuery = NSManagedObject(entity: entity, insertInto: context) as? RecentQuery else { return }
        recentQuery.keyword = keyword
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @discardableResult
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
    
    func addAlarmEntity(_ alarm: AlarmDomainModel) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.alarm.rawValue, in: context),
              let alarmEntity = NSManagedObject(entity: entity, insertInto: context) as? Alarm else { return }
        alarmEntity.isOn = alarm.isOn
        alarmEntity.title = alarm.title
        alarmEntity.message = alarm.message
        alarmEntity.time = alarm.time
        alarmEntity.identifier = alarm.identifier
        alarmEntity.selectedDays = alarm.selectedDaysOfTheWeek
        
        do {
            try context.save ()
        } catch {
            print(error.localizedDescription)
        }
    }
}
