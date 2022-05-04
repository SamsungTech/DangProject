//
//  DefaultFireStoreManagerRepository.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

import FirebaseFirestore

final class DefaultFireStoreManagerRepository: FireStoreManagerRepository {
    let database = Firestore.firestore()
    
    func saveFirebaseUIDDocument(uid: String) {
        
        let uidData = ["firebaeUID": uid]
        database.collection("users").document(uid).setData(uidData) { error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func saveProfileDocument(profile: ProfileDomainModel) {
        let profileData = [
            "uid": profile.uid,
            "name": profile.name,
            "height": profile.height,
            "weight": profile.weight,
            "sugarLevel": profile.sugarLevel,
            "image": "\(profile.profileImage)",
            "onboarding": profile.onboarding,
            "profileExistence": profile.profileExistence
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
    
    func checkProfileField(with fieldName: String, uid: String, completion: @escaping(Bool)->Void) {
        database.collection("app")
            .document(uid)
            .collection("personal")
            .document("profile")
            .getDocument{ snapshot, error in
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
                let string = result.values.map{ "\($0)"}
                completion(string[0])
            }
        }
    }
    
    
}

