//
//  SettingUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import Foundation

class SettingUseCase {
    private var repository: SettingRepository?
    
    init(repository: SettingRepository) {
        self.repository = repository
    }
}
