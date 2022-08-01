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
    case profileEntity = "ProfileEntity"
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
    
    func fetchProfileEntityData() -> ProfileEntity {
        let request = ProfileEntity.fetchRequest()
        do {
            if let checkedProfileEntity = try self.context?.fetch(request) {
                if checkedProfileEntity.count == 0 {
                    return ProfileEntity.init()
                } else {
                    return checkedProfileEntity[0]
                }
            }
        } catch {
            print(error.localizedDescription)
            return ProfileEntity.init()
        }
        return ProfileEntity.init()
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
            updateEatenFood(
                food: food,
                parentEatenFoodsPerDay: eatenFoodsPerDay,
                eatenTime: food.eatenTime.dateValue()
            )
        }
    }
    
    func updateLocalProfileData(_ profileData: ProfileDomainModel) {
        deleteProfileData()
        createProfileData(profileData)
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
        case .profileEntity:
            return loadArrayFromCoreData(request: ProfileEntity.fetchRequest())
        }
    }
    
    func deleteProfileData() {
        let request = ProfileEntity.fetchRequest()
        do {
            if let profileData = try context?.fetch(request) {
                if profileData.count == 0 {
                    return
                } else {
                    context?.delete(profileData[0])
                    try context?.save()
                    return
                }
            } else {
                return
            }
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func createProfileData(_ data: ProfileDomainModel) {
        guard let context = self.context,
              let entity = NSEntityDescription.entity(forEntityName: CoreDataName.profileEntity.rawValue,
                                                      in: context),
              let profileEntity = NSManagedObject(entity: entity, insertInto: context) as? ProfileEntity
        else { return }
        
        let image = data.profileImage.pngData()
        
        profileEntity.name = data.name
        profileEntity.birthday = data.birthday
        profileEntity.gender = data.gender
        profileEntity.sugarLevel = Int32(data.sugarLevel)
        profileEntity.weight = Int32(data.weight)
        profileEntity.height = Int32(data.height)
        profileEntity.profileImage = image
        
        do {
            try context.save()
            print("profile 저장완료")
        } catch {
            print(error.localizedDescription)
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
    
    func updateProfileImageData(_ imageData: UIImage,
                                _ profileData: ProfileDomainModel) {
        var profileData = profileData
        profileData.profileImage = imageData
        
        deleteProfileData()
        createProfileData(profileData)
    }
    
    func fetchProfileImageData() -> Data {
        let request = ProfileEntity.fetchRequest()
        do {
            if let checkedProfileData = try self.context?.fetch(request) {
                if checkedProfileData.count == 0 {
                    return ProfileEntity.init().profileImage ?? Data()
                } else {
                    return checkedProfileData[0].profileImage ?? Data()
                }
            }
        } catch {
            print(error.localizedDescription)
            return ProfileEntity.init().profileImage ?? Data()
        }
        return ProfileEntity.init().profileImage ?? Data()
    }
    
    // MARK: - Private
    
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
        case .profileEntity:
            return ProfileEntity.fetchRequest()
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
}
