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
}

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    func saveFavoriteFoods(_ food: FoodDomainModel) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.favoriteFoods.rawValue, in: context)        else { return }
        guard let favoriteFoods = NSManagedObject(entity: entity, insertInto: context) as? FavoriteFoods else { return }
        
        favoriteFoods.name = food.name
        favoriteFoods.sugar = food.sugar
        favoriteFoods.foodCode = food.foodCode
        
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
}
