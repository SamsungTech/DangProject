//
//  SearchFoodViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/03.
//

import Foundation

import RxSwift

protocol SearchViewModelInput {
    func cancelButtonTapped()
    func changeFavorite(indexPath: IndexPath)
}

protocol SearchViewModelOutput {
    var navigationItemTitle: String { get }
    var searchBarPlaceHolder: String { get }
    var searchBarScopeButtonTitles: [String] { get }
    var searchFoodViewModelObservable: PublishSubject<SearchFoodViewModel> {get}
}

protocol SearchViewModelProtocol: SearchViewModelInput, SearchViewModelOutput {}
class SearchViewModel: SearchViewModelProtocol {
    private let searchFoodUseCase: SearchUseCase
    private let changeFavoriteUseCase: ChangeFavoriteUseCase
    
    var currentKeyword = ""
    var currentFoodViewModels = SearchFoodViewModel.empty
    let disposeBag = DisposeBag()
    
    // MARK: - Input
    func cancelButtonTapped() {
        searchFoodViewModelObservable.onNext(SearchFoodViewModel.empty)
    }
    
    func changeFavorite(indexPath: IndexPath) {
        guard let foodModels = currentFoodViewModels.foodModels else { return }
        changeFavoriteUseCase.changeFavorite(food: foodModels[indexPath.row]) {
            let fetching = CoreDataManager.shared.loadFromCoreData(request: FavoriteFoods.fetchRequest())
            self.searchFoodUseCase.updateViewModel()
        }
        
    }
    
    // MARK: - Output
    let navigationItemTitle = "Search Food"
    let searchBarPlaceHolder = "음식을 검색하세요."
    let searchBarScopeButtonTitles = ["검색결과", "즐겨찾기"]
    var searchFoodViewModelObservable = PublishSubject<SearchFoodViewModel>()
    let loading = PublishSubject<LoadingState>()
    enum LoadingState {
        case startLoading
        case finishLoading
    }

    // MARK: - Init
    init(searchFoodUseCase: SearchUseCase,
         changeFavoriteUseCase: ChangeFavoriteUseCase) {
        self.searchFoodUseCase = searchFoodUseCase
        self.changeFavoriteUseCase = changeFavoriteUseCase
        checkCurrentKeywordAndResult()
    }
    
    func startSearching(food: String) {
        currentKeyword = food
        // 1초후 검색
        searchFoodUseCase.searchFood(text: food)
        loading.onNext(.startLoading)
    }
    
    func checkCurrentKeywordAndResult() {
        searchFoodUseCase.foodResultModelObservable
            .subscribe(onNext: { [self] searchFoodViewModel in
                if self.currentKeyword != searchFoodViewModel.keyWord {
                    searchFoodViewModelObservable.dispose()
                } else if self.currentKeyword == searchFoodViewModel.keyWord {
                   currentFoodViewModels = searchFoodViewModel

                    
                    searchFoodViewModelObservable.onNext(searchFoodViewModel)
                    loading.onNext(.finishLoading)
                }
            })
            .disposed(by: disposeBag)
    }
}

