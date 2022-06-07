//
//  ThemeDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import Foundation

class ThemeDIContainer {
    func makeThemeViewController() -> ThemeViewController {
        return ThemeViewController(viewModel: makeThemeViewModel())
    }
    
    func makeThemeViewModel() -> ThemeViewModel {
        return ThemeViewModel()
    }
}
