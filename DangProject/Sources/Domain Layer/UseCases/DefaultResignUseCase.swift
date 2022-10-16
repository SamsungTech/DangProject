//
//  DefaultResignUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/10/03.
//

import Foundation

class DefaultResignUseCase: ResignUseCase {
    
    let coreDataManagerRepository: CoreDataManagerRepository
    let fireStoreManagerRepository: FireStoreManagerRepository
    
    init(coreDataManagerRepository: CoreDataManagerRepository,
         fireStoreManagerRepository: FireStoreManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.fireStoreManagerRepository = fireStoreManagerRepository
    }
    
    func deleteAllUserData() {
        deleteAllUserCoreData()
        deleteAllUserRemoteData()
        resetDefaultSetting()
        deleteAllUserDefaultsData()
    }
    
    private func deleteAllUserDefaultsData() {
        UserInfoKey.removeAllUserDefaultsDatas()
    }
    
    private func deleteAllUserCoreData() {
        let coreDataNames: [CoreDataName] = [.favoriteFoods, .recentQuery, .eatenFoodsPerDay, .alarm, .profileEntity]
        
        coreDataNames.forEach { coreDataName in
            coreDataManagerRepository.deleteAll(coreDataName: coreDataName)
        }
    }
    
    private func deleteAllUserRemoteData() {
        fireStoreManagerRepository.deleteFirebaseUserDocument()
    }
    
    private func resetDefaultSetting() {
        ProfileDomainModel.isLatestProfileDataValue = false
    }
}
