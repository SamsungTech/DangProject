//
//  FireStoreManagerRepository.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

import RxSwift

protocol FireStoreManagerRepository {
    func uploadFirebaseUserUID(uid: String, ProfileExistence: Bool)
    func saveFirebaseUserDocument(uid: String, ProfileExistence: Bool, completion: @escaping(Bool)->Void)
    func deleteFirebaseUserDocument(completion: @escaping (Bool) -> Void)
    func saveProfileDocument(profile: ProfileDomainModel,
                             completion: @escaping (Bool) -> Void)
    func saveEatenFood(eatenFood: FoodDomainModel,
                       completion: @escaping (Bool) -> Void)
    func checkUIDInFireStore(uid: String,
                             completion: @escaping(Bool)->Void)
    func checkProfileField(with fieldName: String, uid: String, completion: @escaping(Bool)->Void)
    func getEatenFoodsInFirestore(dateComponents: DateComponents) -> Observable<([[String: Any]], Bool)>
    func getProfileDataInFireStore() -> Observable<([String: Any], Bool)>
    func getDemoDataInFireStore(completion: @escaping (Bool) -> Void)
    func changeDemoValue(completion: @escaping ((Bool)->Void))
}
