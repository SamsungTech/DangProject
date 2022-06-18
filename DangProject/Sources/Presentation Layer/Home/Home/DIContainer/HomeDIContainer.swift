//
//  HomeDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import UIKit

class HomeDIContainer {
    
    lazy var fetchEatenFoodsUseCase = self.makeFetchEatenFoodsUseCase()
    
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel(),
                                  eatenFoodsView: makeEatenFoodsView())
    }
    
    func makeEatenFoodsView() -> EatenFoodsView {
        return EatenFoodsView(viewModel: makeEatenFoodsViewModel())
    }
    
    func makeEatenFoodsViewModel() -> EatenFoodsViewModel {
        return EatenFoodsViewModel(fetchEatenFoodsUseCase: fetchEatenFoodsUseCase)
    }
    
    func makeFetchEatenFoodsUseCase() -> FetchEatenFoodsUseCase {
        return DefaultFetchEatenFoodsUseCase(coreDataManagerRepository: makeCoreDataManagerRepository())
    }

    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
    
    func makeHomeViewModel() -> HomeViewModelProtocol {
        return HomeViewModel(useCase: makeHomeUseCase(),
                             fetchEatenFoodsUseCase: fetchEatenFoodsUseCase,
                             calendarService: CalendarService())
    }
    
    func makeHomeUseCase() -> HomeUseCaseProtocol {
        return HomeUseCase(repository: makeHomeRepository())
    }
    
    func makeHomeRepository() -> HomeRepositoryProtocol {
        return HomeRepository()
    }
}
