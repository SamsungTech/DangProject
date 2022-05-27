//
//  DefaultFireStoreManagerRepository.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

import FirebaseFirestore
import RxSwift

final class DefaultFireStoreManagerRepository: FireStoreManagerRepository {
    private let database = Firestore.firestore()

    func saveFirebaseUIDDocument(uid: String) {
        
        let uidData = ["firebaseUID": uid,
                       "onboarding": true,
                       "profileExistence": false
        ] as [String : Any]
        database.collection("users").document(uid).setData(uidData) { error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func saveProfileDocument(profile: ProfileDomainModel) {
        
        let uidData = ["firebaseUID": profile.uid,
                       "onboarding": true,
                       "profileExistence": true
        ] as [String : Any]
        database.collection("users")
            .document(profile.uid)
            .setData(uidData) { error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
        }

        
        let profileData = [
            "uid": profile.uid,
            "name": profile.name,
            "height": profile.height,
            "weight": profile.weight,
            "sugarLevel": profile.sugarLevel,
            "image": "\(profile.profileImage)"
        ] as [String : Any]
        
        database.collection("app")
            .document(profile.uid)
            .collection("personal")
            .document("profile")
            .setData(profileData) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
            }
    }
    
    func saveEatenFood(eatenFood: FoodDomainModel, currentDate: DateComponents) {
        guard let userDefaultsUID = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }

        guard let year = currentDate.year,
              let month = currentDate.month,
              let day = currentDate.day else { return }
        let eatenFoodData = [
            "name": eatenFood.name,
            "sugar": eatenFood.sugar,
            "foodCode": eatenFood.foodCode,
            "favorite": eatenFood.favorite,
            "amount": eatenFood.amount
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
                    }
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
    
}

