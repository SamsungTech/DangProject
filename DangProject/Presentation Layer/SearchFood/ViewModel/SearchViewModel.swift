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
    func eraseQueryResult()
}

protocol SearchViewModelOutput {
    var searchFoodViewModelObservable: PublishSubject<SearchFoodViewModel> { get }
    var searchQueryObservable: PublishSubject<[String]> { get }
    func updateRecentQuery()
}

protocol SearchViewModelProtocol: SearchViewModelInput, SearchViewModelOutput {}

class SearchViewModel: SearchViewModelProtocol {
    let disposeBag = DisposeBag()
    
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
        bindQueryUseCase()
    }
    
    private func bindFoodResultModelObservable() {
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

    private func bindQueryUseCase() {
        manageQueryUseCase.qeuryObservable
            .map({ $0.reversed() })
            .subscribe(onNext: { [unowned self] query in
                searchQueryObservable.onNext(query)
            })
            .disposed(by: disposeBag)
        
    }
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
    
    func selectedScopeDidChanged(to scope: Int) {
        switch scope {
        case 0:
            scopeState = .searchResult
            updateSearchResult()
        case 1:
            scopeState = .favorites
            changeToFavoriteFoods()
        default:
            break
        }
    }
    
    func searchBarTextDidChanged(text: String) {
        switch scopeState {
        case .favorites:
            compareFavoriteResult(text: text)
        case .searchResult:
            startSearching(searchBarText: text)
        case .query:
            startSearching(searchBarText: text)
        }
    }
    
    func eraseQueryResult() {
        manageQueryUseCase.deleteAllQuery()
    }
    
    // MARK: - Output
    var searchFoodViewModelObservable = PublishSubject<SearchFoodViewModel>()
    var searchQueryObservable = PublishSubject<[String]>()
    let loading = PublishSubject<LoadingState>()
    enum LoadingState {
        case startLoading
        case finishLoading
    }
    
    func updateRecentQuery() {
        manageQueryUseCase.updateQuery()
    }
    
    //MARK: - Private Method
    private var currentFoodViewModels = SearchFoodViewModel.empty
    private var favoriteFoodViewModels = SearchFoodViewModel.empty
    private var scopeState: SearchBarScopeState = .searchResult
    enum SearchBarScopeState {
        case searchResult
        case favorites
        case query
    }
    private func startSearching(searchBarText: String) {
        manageQueryUseCase.addQueryOnCoreData(keyword: searchBarText)
        searchFoodUseCase.fetchFood(text: searchBarText)
        loading.onNext(.startLoading)
    }
    
    private func changeToFavoriteFoods() {
        favoriteFoodViewModels = fetchFavoriteFoodsUseCase.fetchFavoriteFoods()
        searchFoodViewModelObservable.onNext(favoriteFoodViewModels)
    }
    
    private func updateSearchResult() {
        scopeState = .searchResult
        searchFoodViewModelObservable.onNext(currentFoodViewModels)
    }
    
    private func updateFavoriteResult() {
        searchFoodViewModelObservable.onNext(favoriteFoodViewModels)
    }
    
    private func compareFavoriteResult(text: String) {
        guard text != "" else { return updateFavoriteResult() }
            let filteredViewModel = favoriteFoodViewModels.foodModels?.filter {(model: FoodViewModel) -> Bool in
                return model.name!.contains(text)
            }
            searchFoodViewModelObservable.onNext(SearchFoodViewModel.init(keyWord: text, foodModels: filteredViewModel ?? []))
    }
}

