//
//  AccountViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/13.
//

import Foundation

import RxSwift
import RxRelay

protocol AccountViewModelInputProtocol: AnyObject {
    func logOutUser(completion: @escaping ((Bool)->Void))
}

protocol AccountViewModelOutputProtocol: AnyObject {
}

protocol AccountViewModelProtocol: AccountViewModelInputProtocol, AccountViewModelOutputProtocol {
    
}

class AccountViewModel: AccountViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let managerFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase
    
    init(managerFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase) {
        self.managerFirebaseFireStoreUseCase = managerFirebaseFireStoreUseCase
    }
    
    func logOutUser(completion: @escaping ((Bool)->Void)) {
        managerFirebaseFireStoreUseCase.changeDemoValue(completion: completion)
        removeUserDefaultsUID()
    }
    
    private func removeUserDefaultsUID() {
        
        UserDefaults.standard.removeObject(forKey: UserInfoKey.firebaseUID)
    }
}
