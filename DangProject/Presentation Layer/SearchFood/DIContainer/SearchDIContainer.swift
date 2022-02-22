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
                               fetchFavoriteFoodsUseCase: makeFetchFoodsUseCase(), manageQueryUseCase: makeManageQueryUseCase())
    }
    
    func makeSearchUseCase() -> SearchUseCase {
        return SearchUseCase(fetchFoodRepository: makeFetchRepository())
    }
    
    func makeFetchFoodsUseCase() -> FetchFavoriteFoodsUseCase {
        return FetchFavoriteFoodsUseCase()
    }
    func makeChangeFavoriteUseCase() -> ChangeFavoriteUseCase {
        return ChangeFavoriteUseCase()
    }
    func makeManageQueryUseCase() -> ManageQueryUseCase {
        return ManageQueryUseCase()
    }
    
    func makeFetchRepository() -> FetchRepository {
        return FetchFoodRepository(fetchDataService: makeRemoteDataService())
    }
            
    func makeRemoteDataService() -> FetchDataService {
        return FetchDataService()
    }
}
