//
//  DetailFoodDIContainer.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/16.
//

import Foundation

class DetailFoodDIContainer {
    
    var selectedFood: FoodViewModel
    init(selectedFood: FoodViewModel) {
        self.selectedFood = selectedFood
    }
    
    func makeDetailFoodViewController() -> DetailFoodViewController {
        return DetailFoodViewController(viewModel: makeDetailFoodViewModel())
    }
    
    func makeDetailFoodViewModel() -> DetailFoodViewModel {
        return DetailFoodViewModel(detailFood: selectedFood, addFoodsUseCase: makeAddFoodsUseCase())
    }
    
    func makeAddFoodsUseCase() -> AddFoodsUseCase {
        return AddFoodsUseCase(coreDataManagerRepository: makeCoreDataManagerRepository())
    }
    
    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }

}
