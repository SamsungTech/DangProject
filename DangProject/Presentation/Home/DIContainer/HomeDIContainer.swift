//
//  HomeDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import UIKit

class HomeDIContainer {
    func makeHomeNavigationViewController() -> UINavigationController {
        let navigationView = UINavigationController(
            rootViewController: makeHomeViewController()
        )
        return navigationView
    }
    
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel())
    }
    
    func makeHomeViewModel() -> HomeViewModelProtocol {
        return HomeViewModel(useCase: makeHomeUseCase(),
                             calendarUseCase: makeCalendarUseCase())
    }
    
    func makeHomeUseCase() -> HomeUseCaseProtocol {
        return HomeUseCase(repository: makeHomeRepository())
    }
    
    func makeCalendarUseCase() -> CalendarUseCaseProtocol {
        return CalendarUseCase(repository: makeHomeRepository())
    }
    
    func makeHomeRepository() -> HomeRepositoryProtocol {
        return HomeRepository()
    }
}
