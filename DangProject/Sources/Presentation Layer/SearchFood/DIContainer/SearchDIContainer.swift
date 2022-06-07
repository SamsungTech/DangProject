//
//  SearchDIContainer.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

class SearchDIContainer {
    
    func makeSearchViewController() -> SearchViewController {
        return SearchViewController(viewModel: makeSearchViewModel())
    }

    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel(searchFoodUseCase: makeSearchUseCase(),
                               changeFavoriteUseCase: makeChangeFavoriteUseCase(),
                               fetchFavoriteFoodsUseCase: makeFetchFoodsUseCase(),
                               manageQueryUseCase: makeManageQueryUseCase())
    }
    
    func makeSearchUseCase() -> SearchUseCase {
        return DefaultSearchUseCase(fetchFoodRepository: makeFetchRepository(),
                             coreDataManagerRepository: makeCoreDataManagerRepository())
    }
    
    func makeFetchFoodsUseCase() -> FetchFavoriteFoodsUseCase {
        return DefaultFetchFavoriteFoodsUseCase(coreDataManagerRepository: makeCoreDataManagerRepository())
    }
    func makeChangeFavoriteUseCase() -> ChangeFavoriteUseCase {
        return DefaultChangeFavoriteUseCase(coreDataManagerRepository: makeCoreDataManagerRepository())
    }
    func makeManageQueryUseCase() -> ManageQueryUseCase {
        return DefaultManageQueryUseCase(coreDataManagerRepository: makeCoreDataManagerRepository())
    }
    
    func makeFetchRepository() -> FetchRepository {
        return DefaultFetchRepository(fetchDataService: makeRemoteDataService())
    }
    
    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
            
    func makeRemoteDataService() -> FetchDataService {
        return FetchDataService()
    }
}
