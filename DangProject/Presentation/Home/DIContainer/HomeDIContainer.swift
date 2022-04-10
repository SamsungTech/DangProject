//
//  HomeDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import UIKit

class HomeDIContainer {
    func presentMemoListViewController(coordinator: Coordinator) -> UINavigationController {
        let navigationView = UINavigationController(
            rootViewController: makeHomeViewController(coordinator: coordinator) as! UIViewController
        )
        return navigationView
    }
    
    func makeHomeViewController(coordinator: Coordinator) -> HomeViewControllerProtocol {
        return HomeViewController.create(viewModel: makeHomeViewModel() as! HomeViewModel,
                                         coordinator: coordinator)
    }
    
    func makeHomeViewModel() -> HomeViewModelProtocol {
        return HomeViewModel(useCase: makeHomeUseCase(), calendarUseCase: makeCalendarUseCase())
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
