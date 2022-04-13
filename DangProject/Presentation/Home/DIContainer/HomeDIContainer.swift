//
//  HomeDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import UIKit

class HomeDIContainer {
    func makeMemoListNavigationViewController(coordinator: Coordinator) -> UINavigationController {
        let navigationView = UINavigationController(
            rootViewController: makeHomeViewController(coordinator: coordinator)
        )
        return navigationView
    }
    
    func makeHomeViewController(coordinator: Coordinator) -> UIViewController {
        guard let coordinator = coordinator as? CoordinateEventProtocol else { return UIViewController() }
        return HomeViewController.create(viewModel: makeHomeViewModel() as! HomeViewModel,
                                         coordinator: coordinator)
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
