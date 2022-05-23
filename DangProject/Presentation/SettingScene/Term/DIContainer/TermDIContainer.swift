//
//  TermDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import Foundation

class TermDIContainer {
    func makeTermViewController() -> TermViewController {
        return TermViewController(viewModel: makeTermViewModel())
    }
    
    func makeTermViewModel() -> TermViewModel {
        return TermViewModel()
    }
}
