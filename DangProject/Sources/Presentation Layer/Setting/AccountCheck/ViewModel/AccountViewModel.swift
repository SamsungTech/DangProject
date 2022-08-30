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
    func logOutUser()
}

protocol AccountViewModelOutputProtocol: AnyObject {
    var profileDataRelay: BehaviorRelay<ProfileDomainModel> { get }
}

protocol AccountViewModelProtocol: AccountViewModelInputProtocol, AccountViewModelOutputProtocol {
    
}

class AccountViewModel: AccountViewModelProtocol {
    private let disposeBag = DisposeBag()
    private var fetchProfileUseCase: ProfileManagerUseCase
    var profileDataRelay = BehaviorRelay<ProfileDomainModel>(value: .empty)
    
    init(fetchProfileUseCase: ProfileManagerUseCase) {
        self.fetchProfileUseCase = fetchProfileUseCase
    }
    
    func fetchProfileData() {
        fetchProfileUseCase.fetchProfileData()
            .subscribe(onNext: { [weak self] in
                self?.profileDataRelay.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func logOutUser() {
        // 유저 로그아웃시 해야할 행동들 (코어데이터 삭제)
        removeUserDefaultsUID()
    }
    
    private func removeUserDefaultsUID() {
        UserDefaults.standard.removeObject(forKey: UserInfoKey.firebaseUID)
    }
}
