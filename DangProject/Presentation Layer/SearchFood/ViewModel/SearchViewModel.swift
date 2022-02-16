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
    func startSearching(food: String)
    func favoriteSearchBarScopeTapped()
}

protocol SearchViewModelOutput {
    var navigationItemTitle: String { get }
    var searchBarPlaceHolder: String { get }
    var searchBarScopeButtonTitles: [String] { get }
    var searchFoodViewModelObservable: PublishSubject<SearchFoodViewModel> { get }
    var favoriteFoodViewModelObsevable: PublishSubject<SearchFoodViewModel> { get }
    func bindFoodResultModelObservable()
}

protocol SearchViewModelProtocol: SearchViewModelInput, SearchViewModelOutput {}
class SearchViewModel: SearchViewModelProtocol {
    
    // MARK: - Init
    private let searchFoodUseCase: SearchUseCase
    private let changeFavoriteUseCase: ChangeFavoriteUseCase
    private let fetchFavoriteFoodsUseCase: FetchFavoriteFoodsUseCase
    init(searchFoodUseCase: SearchUseCase,
         changeFavoriteUseCase: ChangeFavoriteUseCase,
         fetchFavoriteFoodsUseCase: FetchFavoriteFoodsUseCase) {
        self.searchFoodUseCase = searchFoodUseCase
        self.changeFavoriteUseCase = changeFavoriteUseCase
        self.fetchFavoriteFoodsUseCase = fetchFavoriteFoodsUseCase
        bindFoodResultModelObservable()
    }
    
    var currentKeyword = ""
    var currentFoodViewModels = SearchFoodViewModel.empty
    var favoriteFoodViewModels = SearchFoodViewModel.empty
    let disposeBag = DisposeBag()
    
    // MARK: - Input
    func cancelButtonTapped() {
        currentFoodViewModels = SearchFoodViewModel.empty
        searchFoodViewModelObservable.onNext(currentFoodViewModels)
    }
    
    func changeFavorite(indexPath: IndexPath) {
        guard let searchResultFoodModels = currentFoodViewModels.foodModels,
              let favoriteFoodModels = favoriteFoodViewModels.foodModels else { return }
        if scopeState == .searchResult {
            changeFavoriteUseCase.changeFavorite(food: FoodDomainModel.init(searchResultFoodModels[indexPath.row])) {
                self.searchFoodUseCase.updateViewModel()
            }
        } else {
            changeFavoriteUseCase.changeFavorite(food: FoodDomainModel.init(favoriteFoodModels[indexPath.row])) {
                self.favoriteFoodViewModels = self.fetchFavoriteFoodsUseCase.fetchFavoriteFoods()
                self.searchFoodUseCase.updateViewModel()
                self.updateFavoriteFoodViewModelObservable()
                
            }
        }        
    }
    
    func startSearching(food: String) {
        if scopeState == .searchResult {
            currentKeyword = food
            searchFoodUseCase.fetchFood(text: food)
            loading.onNext(.startLoading)
        }
        
    }
    
    func favoriteSearchBarScopeTapped() {
        scopeState = .favorites
        favoriteFoodViewModels = fetchFavoriteFoodsUseCase.fetchFavoriteFoods()
        searchFoodViewModelObservable.onNext(favoriteFoodViewModels)
    }
    
    // MARK: - Output
    let navigationItemTitle = "Search Food"
    let searchBarPlaceHolder = "음식을 검색하세요."
    let searchBarScopeButtonTitles = ["검색결과", "즐겨찾기"]
    var searchFoodViewModelObservable = PublishSubject<SearchFoodViewModel>()
    var favoriteFoodViewModelObsevable = PublishSubject<SearchFoodViewModel>()
    let loading = PublishSubject<LoadingState>()
    enum LoadingState {
        case startLoading
        case finishLoading
    }
    var scopeState: SearchBarScopeState = .searchResult
    enum SearchBarScopeState {
        case searchResult
        case favorites
    }
    
    func bindFoodResultModelObservable() {
        searchFoodUseCase.foodResultModelObservable
            .subscribe(onNext: { [self] searchFoodViewModel in
                currentFoodViewModels = searchFoodViewModel
                if scopeState == .searchResult {
                    updateSearchFoodViewModelObservable()
                } else if scopeState == .favorites {
                    updateFavoriteFoodViewModelObservable()
                }
                loading.onNext(.finishLoading)
            })
            .disposed(by: disposeBag)
    }
    
    func updateSearchFoodViewModelObservable() {
        scopeState = .searchResult
        searchFoodViewModelObservable.onNext(currentFoodViewModels)
    }
    func updateFavoriteFoodViewModelObservable() {
        searchFoodViewModelObservable.onNext(favoriteFoodViewModels)
    }
}

