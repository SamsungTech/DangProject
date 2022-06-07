//
//  AppIntroduceDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import Foundation

class AppIntroduceDIContainer {
    func makeAppIntroduceViewController() -> AppIntroduceViewController {
        return AppIntroduceViewController(viewModel: makeAppIntroduceViewModel())
    }
    
    func makeAppIntroduceViewModel() -> AppIntroduceViewModel {
        return AppIntroduceViewModel()
    }
}
