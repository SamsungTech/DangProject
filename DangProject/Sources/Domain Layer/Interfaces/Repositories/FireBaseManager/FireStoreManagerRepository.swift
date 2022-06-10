//
//  FireStoreManagerRepository.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

protocol FireStoreManagerRepository {
        
    func saveFirebaseUserDocument(uid: String, ProfileExistence: Bool)
    func saveProfileDocument(profile: ProfileDomainModel)
    func saveEatenFood(eatenFood: FoodDomainModel, currentDate: DateComponents)
    
    func readUIDInFirestore(uid: String, completion: @escaping(String)->Void)
    func checkProfileField(with fieldName: String, uid: String, completion: @escaping(Bool)->Void)
}
