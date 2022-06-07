//
//  MyTargetDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import Foundation

class MyTargetDIContainer {
    func makeMyTargetViewController() -> MyTargetViewController {
        return MyTargetViewController(viewModel: makeMyTargetViewModel())
    }
    
    func makeMyTargetViewModel() -> MyTargetViewModel {
        return MyTargetViewModel()
    }
}
