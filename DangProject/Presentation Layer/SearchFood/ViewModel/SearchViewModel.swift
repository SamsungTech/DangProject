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
    func changeFavorite(indexPath: IndexPath?, foodModel: FoodViewModel?)
    func startSearching(searchBarText: String)
    func favoriteSearchBarScopeTapped()
    func eraseQueryResult()
}

protocol SearchViewModelOutput {
    var navigationItemTitle: String { get }
    var searchBarPlaceHolder: String { get }
    var searchBarScopeButtonTitles: [String] { get }
    var currentKeyword: String { get }
    var currentFoodViewModels: SearchFoodViewModel { get }
    var favoriteFoodViewModels: SearchFoodViewModel { get }
    var searchFoodViewModelObservable: PublishSubject<SearchFoodViewModel> { get }
    var searchQueryObservable: PublishSubject<[String]> { get }
    func bindFoodResultModelObservable()
    func updateSearchResult()
    func updateFavoriteResult()
    func updateRecentQuery()
    func compareFavoriteResult(text: String)
}

protocol SearchViewModelProtocol: SearchViewModelInput, SearchViewModelOutput {}
class SearchViewModel: SearchViewModelProtocol {
    
    // MARK: - Init
    private let searchFoodUseCase: SearchUseCase
    private let changeFavoriteUseCase: ChangeFavoriteUseCase
    private let fetchFavoriteFoodsUseCase: FetchFavoriteFoodsUseCase
    private let manageQueryUseCase: ManageQueryUseCase
    init(searchFoodUseCase: SearchUseCase,
         changeFavoriteUseCase: ChangeFavoriteUseCase,
         fetchFavoriteFoodsUseCase: FetchFavoriteFoodsUseCase,
         manageQueryUseCase: ManageQueryUseCase) {
        self.searchFoodUseCase = searchFoodUseCase
        self.changeFavoriteUseCase = changeFavoriteUseCase
        self.fetchFavoriteFoodsUseCase = fetchFavoriteFoodsUseCase
        self.manageQueryUseCase = manageQueryUseCase
        bindFoodResultModelObservable()
        self.searchQueryObservable.onNext(self.manageQueryUseCase.loadQuery().reversed())
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: - Input
    func cancelButtonTapped() {
        currentFoodViewModels = SearchFoodViewModel.empty
        searchFoodViewModelObservable.onNext(currentFoodViewModels)
    }
    
    func changeFavorite(indexPath: IndexPath?, foodModel: FoodViewModel?) {
        guard let searchResultFoodModels = currentFoodViewModels.foodModels,
              let favoriteFoodModels = favoriteFoodViewModels.foodModels else { return }
        
        if indexPath != nil {
            if scopeState == .searchResult {
                changeFavoriteUseCase.changeFavorite(food: FoodDomainModel.init(searchResultFoodModels[indexPath!.row])) {
                    self.searchFoodUseCase.updateViewModel()
                }
            } else {
                changeFavoriteUseCase.changeFavorite(food: FoodDomainModel.init(favoriteFoodModels[indexPath!.row])) {
                    self.favoriteFoodViewModels = self.fetchFavoriteFoodsUseCase.fetchFavoriteFoods()
                    self.searchFoodUseCase.updateViewModel()
                    self.updateFavoriteResult()
                }
            }
        } else if foodModel != nil {
            if scopeState == .searchResult {
                changeFavoriteUseCase.changeFavorite(food: FoodDomainModel.init(foodModel!)) {
                    self.searchFoodUseCase.updateViewModel()
                }
            } else {
                changeFavoriteUseCase.changeFavorite(food: FoodDomainModel.init(foodModel!)) {
                    self.favoriteFoodViewModels = self.fetchFavoriteFoodsUseCase.fetchFavoriteFoods()
                    self.searchFoodUseCase.updateViewModel()
                    self.updateFavoriteResult()
                }
            }
        }
        
    }
    
    // MARK: 재인 - scopeState를 보고 분기
    func startSearching(searchBarText: String) {
//        switch scopeState {
//        case .query: break
//        case .favorites: break
//        case .searchResult:
//            searchResultTextDidChanged(text: searchBarText)
//        }
//        
        scopeState = .searchResult
        guard currentKeyword != searchBarText else { return }
        currentKeyword = searchBarText
        manageQueryUseCase.addQueryOnCoreData(keyword: searchBarText) {
            self.updateRecentQuery()
        }
        searchFoodUseCase.fetchFood(text: searchBarText)
        loading.onNext(.startLoading)
    }
    
//    private func searchResultTextDidChanged(text: String) {
//        // debounce 여기
//        
//    }
    func favoriteSearchBarScopeTapped() {
        scopeState = .favorites
        favoriteFoodViewModels = fetchFavoriteFoodsUseCase.fetchFavoriteFoods()
        searchFoodViewModelObservable.onNext(favoriteFoodViewModels)
    }
    
    func eraseQueryResult() {
        manageQueryUseCase.deleteAllQuery()
        updateRecentQuery()
    }
    
    // MARK: - Output
    let navigationItemTitle = "음식 추가"
    let searchBarPlaceHolder = "음식을 검색하세요."
    let searchBarScopeButtonTitles = ["검색결과", "즐겨찾기"]
    var currentKeyword = ""
    var currentFoodViewModels = SearchFoodViewModel.empty
    var favoriteFoodViewModels = SearchFoodViewModel.empty
    var searchFoodViewModelObservable = PublishSubject<SearchFoodViewModel>()
    var searchQueryObservable = PublishSubject<[String]>()
    let loading = PublishSubject<LoadingState>()
    enum LoadingState {
        case startLoading
        case finishLoading
    }
    var scopeState: SearchBarScopeState = .searchResult
    enum SearchBarScopeState {
        case query
        case searchResult
        case favorites
    }
    
    func bindFoodResultModelObservable() {
        searchFoodUseCase.foodResultModelObservable
            .subscribe(onNext: { [self] searchFoodViewModel in
                currentFoodViewModels = searchFoodViewModel
                if scopeState == .searchResult {
                    updateSearchResult()
                } else if scopeState == .favorites {
                    updateFavoriteResult()
                }
                loading.onNext(.finishLoading)
            })
            .disposed(by: disposeBag)
    }
    
    func updateSearchResult() {
        scopeState = .searchResult
        searchFoodViewModelObservable.onNext(currentFoodViewModels)
    }
    
    func updateFavoriteResult() {
        searchFoodViewModelObservable.onNext(favoriteFoodViewModels)
    }
    
    func updateRecentQuery() {
        self.searchQueryObservable.onNext(self.manageQueryUseCase.loadQuery().reversed())
    }
    
    func compareFavoriteResult(text: String) {
        guard text != "" else { return updateFavoriteResult() }
            let filteredViewModel = favoriteFoodViewModels.foodModels?.filter {(model: FoodViewModel) -> Bool in
                return model.name!.contains(text)
            }
            searchFoodViewModelObservable.onNext(SearchFoodViewModel.init(keyWord: text, foodModels: filteredViewModel ?? []))
    }
}

