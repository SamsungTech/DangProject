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

    func saveFirebaseUserDocument(uid: String, ProfileExistence: Bool) {

        let uidData = ["firebaseUID": uid,
                       "profileExistence": ProfileExistence
        ] as [String : Any]

        database.collection("users")
            .document(uid)
            .setData(uidData) { error in

            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func saveProfileDocument(profile: ProfileDomainModel) {
        
        let profileData = [
            "uid": self.uid,
            "name": profile.name,
            "height": profile.height,
            "weight": profile.weight,
            "sugarLevel": profile.sugarLevel,
            "gender": "\(profile.gender.rawValue)",
            "birthDay": "\(profile.birthday)"
        ] as [String : Any]
        
        database.collection("app")
            .document(self.uid)
            .collection("personal")
            .document("profile")
            .setData(profileData) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
            }
    }
    
    func getProfileDataInFireStore() -> Observable<[String: Any]> {
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
                            return
                        }
                        if let result = snapshot?.data() {
                            emitter.onNext(result)
                        }
                    }
                return Disposables.create()
            }
        }
    
    func saveEatenFood(eatenFood: FoodDomainModel) {
        guard let userDefaultsUID = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }
        let today = DateComponents.currentDateTimeComponents()
        guard let year = today.year,
              let month = today.month,
              let day = today.day else { return }
        let eatenFoodData = [
            "name": eatenFood.name,
            "sugar": eatenFood.sugar,
            "foodCode": eatenFood.foodCode,
            "favorite": eatenFood.favorite,
            "amount": eatenFood.amount,
            "eatenTime": eatenFood.eatenTime
        ] as [String : Any]
        
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
                    return
                }
            }
    }
    
    func checkProfileField(with fieldName: String, uid: String, completion: @escaping(Bool)->Void) {
        database.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            if let result = snapshot?.data() {
                if let resultBool = result[fieldName] {
                    completion(resultBool as! Bool)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }

    }
    
    func readUIDInFirestore(uid: String, completion: @escaping(String)->Void) {
        database.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            if let result = snapshot?.data() {
                if let resultUID = result["firebaseUID"] {
                    completion(resultUID as! String)
                }
            }
        }
    }
    
    func getEatenFoodsInFirestore(dateComponents: DateComponents) -> Observable<[[String: Any]]> {
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
                        return
                    }
                    if let result = snapshot?.documents {
                        emitter.onNext(result.map{ $0.data() })
                    }
                }
            return Disposables.create()
        }
    }
    
    func getGraphAllYearDataInFireStore() -> Observable<[[String:Any]]> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.database.collection("app")
                .document(strongSelf.uid)
                .collection("graph")
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        return
                    }
                    if let result = snapshot?.documents {
                        emitter.onNext(result.map { $0.data() })
                    }
                }
            return Disposables.create()
        }
    }
    
    func getGraphAllThisMonthDataInFireStore() -> Observable<[[String:Any]]> {
        return Observable.create { [weak self] emitter in
            let today = DateComponents.currentDateTimeComponents()
            guard let strongSelf = self,
                  let year = today.year else {
                return Disposables.create()
            }
            self?.database.collection("app")
                .document(strongSelf.uid)
                .collection("graph")
                .document("year")
                .collection("\(year)")
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        return
                    }
                    if let result = snapshot?.documents {
                        emitter.onNext(result.map { $0.data() })
                    }
                }
            return Disposables.create()
        }
    }
    
    func getGraphAllThisDaysDataInFireStore() -> Observable<[[String:Any]]> {
        return Observable.create { [weak self] emitter in
            let today = DateComponents.currentDateTimeComponents()
            guard let strongSelf = self,
                  let year = today.year,
                  let month = today.month else {
                return Disposables.create()
            }
            
            self?.database.collection("app")
                .document(strongSelf.uid)
                .collection("graph")
                .document("year")
                .collection("\(year)")
                .document("month")
                .collection("\(month)")
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        return
                    }
                    if let result = snapshot?.documents {
                        emitter.onNext(result.map { $0.data() })
                        
                    }
                }
            return Disposables.create()
        }
    }
    
    func setGraphDaysDataInFireStore(_ data: [String : Any]) {
        guard let userDefaultsUID = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }
        let today = DateComponents.currentDateTimeComponents()
        guard let year = today.year,
              let month = today.month else { return }
        
        database.collection("app")
            .document(userDefaultsUID)
            .collection("graph")
            .document("year")
            .collection("\(year)")
            .document("month")
            .collection("\(month)")
            .document("day")
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
            }
    }
    
    func setGraphMonthDataInFireStore(_ data: [String : Any]) {
        guard let userDefaultsUID = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }
        let today = DateComponents.currentDateTimeComponents()
        guard let year = today.year else { return }
        
        database.collection("app")
            .document(userDefaultsUID)
            .collection("graph")
            .document("year")
            .collection("\(year)")
            .document("month")
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
            }
    }
    
    func setGraphYearDataInFireStore(_ data: [String : Any]) {
        guard let userDefaultsUID = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }

        database.collection("app")
            .document(userDefaultsUID)
            .collection("graph")
            .document("year")
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
            }
    }
}


