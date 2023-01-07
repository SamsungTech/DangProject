//
//  SecessionViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import Foundation

protocol SecessionViewModelInputProtocol {
    func resignUser(completion: @escaping (Bool) -> Void)
}

protocol SecessionViewModelOutputProtocol {
    
}

protocol SecessionViewModelProtocol: SecessionViewModelInputProtocol, SecessionViewModelOutputProtocol {
    
}

class SecessionViewModel: SecessionViewModelProtocol {
    let resignUseCase: ResignUseCase
    
    init(resignUseCase: ResignUseCase) {
        self.resignUseCase = resignUseCase
    }
    
    func resignUser(completion: @escaping (Bool) -> Void) {
        resignUseCase.deleteAllUserData(completion: completion)
    }
}
