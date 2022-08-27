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
    
}

protocol AccountViewModelOutputProtocol: AnyObject {
    var profileDataRelay: BehaviorRelay<ProfileDomainModel> { get }
}

protocol AccountViewModelProtocol: AccountViewModelInputProtocol, AccountViewModelOutputProtocol {
    
}

class AccountViewModel: AccountViewModelProtocol {
    private let disposeBag = DisposeBag()
    private var fetchProfileUseCase: FetchProfileUseCase
    var profileDataRelay = BehaviorRelay<ProfileDomainModel>(value: .empty)
    
    init(fetchProfileUseCase: FetchProfileUseCase) {
        self.fetchProfileUseCase = fetchProfileUseCase
        bindProfileData()
    }
    
    func fetchProfileData() {
        fetchProfileUseCase.fetchProfileData()
    }
    
    private func bindProfileData() {
        fetchProfileUseCase.profileDataSubject
            .subscribe(onNext: { [weak self] profileData in
                self?.profileDataRelay.accept(profileData)
            })
            .disposed(by: disposeBag)
    }
}
