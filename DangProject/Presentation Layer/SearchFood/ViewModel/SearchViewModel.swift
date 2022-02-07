//
//  SearchFoodViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/03.
//

import Foundation

protocol SearchViewModelInput {
}

protocol SearchViewModelOutput {
    var navigationItemTitle: String { get }
    var searchBarPlaceHolder: String { get }
    var searchBarScopeButtonTitles: [String] { get }
}

protocol SearchViewModelProtocol: SearchViewModelInput, SearchViewModelOutput {}
class SearchViewModel: SearchViewModelProtocol {
    private let searchFoodUseCase: SearchUseCase
    
    // MARK: - Output
    let navigationItemTitle = "Search Food"
    let searchBarPlaceHolder = "음식을 검색하세요."
    let searchBarScopeButtonTitles = ["검색결과", "즐겨찾기"]
    
    // MARK: - Init
    init(searchFoodUseCase: SearchUseCase) {
        self.searchFoodUseCase = searchFoodUseCase
    }
}
