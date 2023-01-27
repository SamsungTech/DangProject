//
//  DefaultFireStoreManagerRepositroy.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/19.
//

import Foundation

import FirebaseCore
import FirebaseFirestore
import FirebaseAnalytics
import Firebase

import RxSwift

class DefaultFireStoreManagerRepository: FireStoreManagerRepository {
    private lazy var uid = UserInfoKey.getUserDefaultsUID
    private let database = Firestore.firestore()
    
    func getDemoDataInFireStore(completion: @escaping (Bool) -> Void) {
        database.collection("app")
            .document("Demo")
            .getDocument() { snapshot, error  in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                if let result = snapshot?.data() {
                    var demoData: Bool = false
                    for (key, value) in result {
                        switch key {
                        case "isDemo": demoData = value as? Bool ?? true
                        default: break
                        }
                    }
                    completion(demoData)
                }
            }
    }
    
    func changeDemoValue(completion: @escaping ((Bool)->Void)) {
        database.collection("app")
            .document("Demo")
            .setData(["isDemo": false]) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion(true)
            }
    }
    
    func uploadFirebaseUserUID(uid: String, ProfileExistence: Bool) {
        let uidData = ["firebaseUID": uid,
                       "profileExistence": ProfileExistence
        ] as [String : Any]
        
        database.collection("users")
            .document(self.uid)
            .setData(uidData) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
            }
    }

    
    func saveFirebaseUserDocument(uid: String,
                                  ProfileExistence: Bool,
                                  completion: @escaping (Bool)->Void) {
        let uidData = ["firebaseUID": self.uid,
                       "profileExistence": ProfileExistence
        ] as [String : Any]
        
        database.collection("users")
            .document(self.uid)
            .setData(uidData) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    func deleteFirebaseUserDocument(completion: @escaping (Bool) -> Void) {
        self.getEatenFoodsStrings(completion: completion)
    }
    
    private func deleteUserInformationInApp() {
        database.collection("app")
            .document(uid)
            .collection("eatenFoods")
            .document("2023")
            .delete { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
            }
    }
    
    func saveProfileDocument(profile: ProfileDomainModel,
                             completion: @escaping (Bool) -> Void) {
        let profileData = [
            "uid": profile.uid,
            "name": profile.name,
            "height": profile.height,
            "weight": profile.weight,
            "sugarLevel": profile.sugarLevel
        ] as [String : Any]
        
        database.collection("app")
            .document(self.uid)
            .collection("personal")
            .document("profile")
            .setData(profileData) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    func getProfileDataInFireStore() -> Observable<([String: Any], Bool)> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else {
                return Disposables.create()
            }
            
            self?.database.collection("app")
                .document(strongSelf.uid)
                .collection("personal")
                .document("profile")
                .getDocument() { snapshot, error  in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        emitter.onNext(([:], false))
                        return
                    }
                    if let result = snapshot?.data() {
                        emitter.onNext((result, true))
                    }
                }
            return Disposables.create()
        }
    }
    
    func saveEatenFood(eatenFood: FoodDomainModel,
                       completion: @escaping (Bool) -> Void) {
        guard let userDefaultsUID = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }
        let today = DateComponents.currentDateTimeComponents()
        guard let year = today.year,
              let month = today.month,
              let day = today.day else {
            
            return
        }
        let eatenFoodData = [
            "name": eatenFood.name,
            "sugar": eatenFood.sugar,
            "foodCode": eatenFood.foodCode,
            "favorite": eatenFood.favorite,
            "amount": eatenFood.amount,
            "eatenTime": eatenFood.eatenTime
        ] as [String : Any]
        
        self.saveEatenFoodDataForDelete(foodName: eatenFood.name,
                                        foodCode: eatenFood.foodCode,
                                        completion: completion)
        
        database.collection("app")
            .document(userDefaultsUID)
            .collection("foods")
            .document("eatenFoods")
            .collection("\(year)년")
            .document("\(month)월")
            .collection("\(day)일")
            .document("\(eatenFood.name)")
            .setData(eatenFoodData) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    private func saveEatenFoodDataForDelete(foodName: String,
                                            foodCode: String,
                                            completion: @escaping(Bool)->Void) {
        guard let userDefaultsUID = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }
        let today = DateComponents.currentDateTimeComponents()
        guard let year = today.year,
              let month = today.month,
              let day = today.day else { return }
        
        let eatenFoodData = [
            "year": "\(year)",
            "month": "\(month)",
            "day": "\(day)",
            "foodName": foodName
        ] as [String : Any]
        
        database.collection("app")
            .document(userDefaultsUID)
            .collection("foods")
            .document("eatenFoodsForDelete")
            .collection("forDelete")
            .document(foodCode)
            .setData(eatenFoodData) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    func checkProfileField(with fieldName: String, uid: String,
                           completion: @escaping(Bool)->Void) {
        database.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let result = snapshot?.data() {
                if let resultBool = result[fieldName] as? Bool {
                    completion(resultBool)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        
    }
    
    func checkUIDInFireStore(uid: String,
                             completion: @escaping(Bool)->Void) {
        database.collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if snapshot?.data() == nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
    }
    
    func getEatenFoodsInFirestore(dateComponents: DateComponents) -> Observable<([[String: Any]], Bool)> {
        return Observable.create { [weak self] emitter in
            guard let year = dateComponents.year,
                  let month = dateComponents.month,
                  let day = dateComponents.day,
                  let strongSelf = self else {
                return Disposables.create()
            }
            self?.database.collection("app")
                .document(strongSelf.uid)
                .collection("foods")
                .document("eatenFoods")
                .collection("\(year)년")
                .document("\(month)월")
                .collection("\(day)일")
                .getDocuments() { snapshot, error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        emitter.onNext(([], false))
                        return
                    }
                    if let result = snapshot?.documents {
                        emitter.onNext((result.map{ $0.data() }, true))
                    }
                }
            return Disposables.create()
        }
    }
    
    func getEatenFoodsStrings(completion: @escaping (Bool) -> Void) {
        self.database.collection("app")
            .document(uid)
            .collection("foods")
            .document("eatenFoodsForDelete")
            .collection("forDelete")
            .getDocuments() { snapshot, error in
                if ((snapshot?.isEmpty) != nil) {
                    self.removeUsesUID(completion: completion)
                }
                
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                if let result = snapshot?.documents {
                    let result = self.convertEatenFoodsToString(data:result.map{ $0.data() })
                    self.removeAllEatenFoodsData(eatenFoods: result, completion: completion)
                }
            }
    }
    
    private func convertEatenFoodsToString(data: [[String:Any]]) -> [EatenFoodForDelete] {
        var foodsStringArray: [EatenFoodForDelete] = []
        data.forEach { foods in
            var eatenFoodForDelete: EatenFoodForDelete = .empty
            for (key, value) in foods {
                switch key {
                case "year": eatenFoodForDelete.year = value as? String ?? ""
                case "month": eatenFoodForDelete.month = value as? String ?? ""
                case "day": eatenFoodForDelete.day = value as? String ?? ""
                case "foodName": eatenFoodForDelete.foodName = value as? String ?? ""
                default: break
                }
            }
            foodsStringArray.append(eatenFoodForDelete)
        }
        return foodsStringArray
    }
    
    private func removeAllEatenFoodsData(eatenFoods: [EatenFoodForDelete],
                                         completion: @escaping (Bool) -> Void) {
        eatenFoods.forEach {
            database.collection("app")
                .document(uid)
                .collection("foods")
                .document("eatenFoods")
                .collection("\($0.year)년")
                .document("\($0.month)월")
                .collection("\($0.day)일")
                .document($0.foodName)
                .delete { error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    self.removeAllEatenFoodForDeleteData(completion: completion)
                }
        }
    }
    
    private func removeAllEatenFoodForDeleteData(completion: @escaping (Bool) -> Void) {
        database.collection("app")
            .document(uid)
            .collection("foods")
            .document("eatenFoodsForDelete")
            .delete { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                self.removeAppUID(completion: completion)
            }
    }
    
    private func removeAppUID(completion: @escaping (Bool) -> Void) {
        database.collection("app")
            .document(uid)
            .delete { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                self.removeUsesUID(completion: completion)
            }
    }
    
    private func removeUsesUID(completion: @escaping (Bool) -> Void) {
        database.collection("users")
            .document(uid)
            .delete { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                self.removePersonalProfile(completion: completion)
            }
    }
    
    private func removePersonalProfile(completion: @escaping (Bool) -> Void) {
        database.collection("app")
            .document(uid)
            .collection("personal")
            .document("profile")
            .delete { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
    }
}
