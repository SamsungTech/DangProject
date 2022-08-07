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
    }
    
    func fetchProfileData() {
        fetchProfileUseCase.fetchProfileData()
            .subscribe(onNext: { [weak self] in
                self?.profileDataRelay.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
