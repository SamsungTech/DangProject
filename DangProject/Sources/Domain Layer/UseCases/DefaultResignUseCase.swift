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
    
    func deleteAllUserData(completion: @escaping (Bool) -> Void) {
        fireStoreManagerRepository.changeDemoValue(completion: { _ in })
        deleteAllUserCoreData()
        resetDefaultSetting()
        deleteAllUserDefaultsData()
        deleteAllUserRemoteData(completion: completion)
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
    
    private func deleteAllUserRemoteData(completion: @escaping (Bool) -> Void) {
        fireStoreManagerRepository.deleteFirebaseUserDocument(completion: completion)
    }
    
    private func resetDefaultSetting() {
        ProfileDomainModel.isLatestProfileDataValue = false
    }
}
