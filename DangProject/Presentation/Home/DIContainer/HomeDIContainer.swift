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
        let navigationView = UINavigationController(rootViewController: makeHomeViewController(coordinator: coordinator))
        return navigationView
    }
    func makeHomeViewController(coordinator: Coordinator) -> HomeViewController {
        return HomeViewController.create(viewModel: makeHomeViewModel() as! HomeViewModel,
                                         coordinator: coordinator)
    }
    func makeHomeViewModel() -> HomeViewModelProtocol {
        return HomeViewModel(useCase: makeHomeUseCase())
    }
    func makeHomeUseCase() -> HomeUseCase {
        return HomeUseCase(repository: makeTampRepository())
    }
    func makeTampRepository() -> TempRepository {
        return TempRepository()
    }
}
