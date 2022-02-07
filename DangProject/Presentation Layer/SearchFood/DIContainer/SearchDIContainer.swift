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
        return SearchViewModel(searchFoodUseCase: makeSearchUseCase())
    }
    
    func makeSearchUseCase() -> SearchUseCase {
        return SearchUseCase(fetchFoodRepository: makeFetchRepository())
    }
    
    func makeFetchRepository() -> FetchRepository {
        return FetchFoodRepository()
    }
}
