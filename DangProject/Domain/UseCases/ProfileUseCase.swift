//
//  ProfileUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
// qusrud

import Foundation

protocol ProfileUseCaseProtocol {
    
}

class ProfileUseCase: ProfileUseCaseProtocol {
    var repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
}

