//
//  FireStoreManagerRepository.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

import RxSwift

protocol FireStoreManagerRepository {
    
    func saveFirebaseUserDocument(uid: String, ProfileExistence: Bool)
    func deleteFirebaseUserDocument()
    func saveProfileDocument(profile: ProfileDomainModel,
                             completion: @escaping (Bool) -> Void)
    func saveEatenFood(eatenFood: FoodDomainModel,
                       completion: @escaping (Bool) -> Void)
    func readUIDInFirestore(uid: String, completion: @escaping(String)->Void)
    func checkProfileField(with fieldName: String, uid: String, completion: @escaping(Bool)->Void)
    func getEatenFoodsInFirestore(dateComponents: DateComponents) -> Observable<[[String: Any]]>
    func getProfileDataInFireStore() -> Observable<[String: Any]>
}
