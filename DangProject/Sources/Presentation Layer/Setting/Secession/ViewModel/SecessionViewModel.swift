//
//  SecessionViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import Foundation

protocol SecessionViewModelInputProtocol {
    func resignUser()
}

protocol SecessionViewModelOutputProtocol {
    
}

protocol SecessionViewModelProtocol: SecessionViewModelInputProtocol, SecessionViewModelOutputProtocol {
    
}

class SecessionViewModel: SecessionViewModelProtocol {
    func resignUser() {
        // 유저 탈퇴시 해야할 행동들 (로컬데이터, 리모트데이터 삭제)
        deleteAllUserDefaultsDatas()
    }
    
    private func deleteAllUserDefaultsDatas() {
        UserInfoKey.removeAllUserDefaultsDatas()
    }
}
