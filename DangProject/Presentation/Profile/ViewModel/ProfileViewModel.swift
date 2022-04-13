//
//  ProfileViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import Foundation

protocol ProfileViewModelInputProtocol {
    
}

protocol ProfileViewModelOutputProtocol {
    
}

protocol ProfileViewModelProtocol: ProfileViewModelInputProtocol, ProfileViewModelOutputProtocol {
    
}

class ProfileViewModel: ProfileViewModelProtocol {
    private var profileUseCase: ProfileUseCaseProtocol?
    
    init(useCase: ProfileUseCaseProtocol) {
        self.profileUseCase = useCase
    }
}
