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
    func saveProfileDocument(profile: ProfileDomainModel)
    func saveEatenFood(eatenFood: FoodDomainModel)
    func readUIDInFirestore(uid: String, completion: @escaping(String)->Void)
    func checkProfileField(with fieldName: String, uid: String, completion: @escaping(Bool)->Void)
    func getEatenFoodsInFirestore() -> Observable<[[String: Any]]>
    func getProfileDataInFireStore() -> Observable<[String: Any]>
    
    
    
    func getGraphAllYearDataInFireStore() -> Observable<[[String: Any]]>
    func getGraphAllThisMonthDataInFireStore() -> Observable<[[String:Any]]>
    func getGraphAllThisDaysDataInFireStore() -> Observable<[[String:Any]]>
}
