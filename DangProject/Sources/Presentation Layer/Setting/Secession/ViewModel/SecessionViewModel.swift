//
//  SecessionViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import Foundation

import RxSwift
import RxRelay

protocol SecessionViewModelInputProtocol {
    func resignUser(completion: @escaping (Bool) -> Void)
}

protocol SecessionViewModelOutputProtocol {
    var loading: PublishRelay<LoadingState> { get }
}

protocol SecessionViewModelProtocol: SecessionViewModelInputProtocol, SecessionViewModelOutputProtocol {
    
}

class SecessionViewModel: SecessionViewModelProtocol {
    private let resignUseCase: ResignUseCase
    let loading = PublishRelay<LoadingState>()
    
    init(resignUseCase: ResignUseCase) {
        self.resignUseCase = resignUseCase
    }
    
    func resignUser(completion: @escaping (Bool) -> Void) {
        resignUseCase.deleteAllUserData(completion: completion)
    }
    
    func removeFirebaseUID() {
        UserDefaults.standard.removeObject(forKey: UserInfoKey.firebaseUID)
    }
}
