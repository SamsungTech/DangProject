//
//  AccountDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/13.
//

import Foundation

class AccountDIContainer {
    func makeAccountViewController() -> AccountViewController {
        return AccountViewController(viewModel: makeAccountViewModel())
    }
    
    func makeAccountViewModel() -> AccountViewModel {
        return AccountViewModel()
    }
}
