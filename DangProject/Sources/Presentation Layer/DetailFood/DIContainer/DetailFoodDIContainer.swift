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
        return DetailFoodViewModel(detailFood: selectedFood,
                                   addFoodsUseCase: makeAddFoodsUseCase(),
                                   fetchGraphDataUseCase: makeFetchGraphDataUseCase())
    }
    
    func makeAddFoodsUseCase() -> AddFoodsUseCase {
        return DefaultAddFoodsUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                      firebaseFireStoreUseCase: makeManageFireBaseFireStoreUseCase())
    }
    
    func makeFetchGraphDataUseCase() -> DefaultFetchGraphDataUseCase {
        return DefaultFetchGraphDataUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository(),
                                            coreDataManagerRepository: makeCoreDataManagerRepository())
    }
    
    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
    
    func makeManageFireBaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
}
