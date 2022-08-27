//
//  SearchFoodViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/03.
//

import Foundation

import RxCocoa
import RxSwift

protocol SearchViewModelInput {
    var currentKeyword: String { get }
    func cancelButtonTapped()
    func changeFavorite(indexPath: IndexPath?, foodModel: FoodViewModel?)
    func eraseQueryResult()
    func fetchTargetSugarData()
}

protocol SearchViewModelOutput {
    var searchFoodViewModelObservable: PublishRelay<[FoodViewModel]> { get }
    var searchQueryObservable: PublishRelay<[String]> { get }
    var targetSugarRelay: BehaviorRelay<Double> { get }
    func updateRecentQuery()
}

protocol SearchViewModelProtocol: SearchViewModelInput, SearchViewModelOutput {}

class SearchViewModel: SearchViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    private let searchFoodUseCase: SearchUseCase
    private let changeFavoriteUseCase: ChangeFavoriteUseCase
    private let fetchFavoriteFoodsUseCase: FetchFavoriteFoodsUseCase
    private let manageQueryUseCase: ManageQueryUseCase
    private let fetchProfileUseCase: FetchProfileUseCase
    var targetSugarRelay = BehaviorRelay<Double>(value: 0.0)
    
    init(searchFoodUseCase: SearchUseCase,
         changeFavoriteUseCase: ChangeFavoriteUseCase,
         fetchFavoriteFoodsUseCase: FetchFavoriteFoodsUseCase,
         manageQueryUseCase: ManageQueryUseCase,
         fetchProfileUseCase: FetchProfileUseCase) {
        self.searchFoodUseCase = searchFoodUseCase
        self.changeFavoriteUseCase = changeFavoriteUseCase
        self.fetchFavoriteFoodsUseCase = fetchFavoriteFoodsUseCase
        self.manageQueryUseCase = manageQueryUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        bindFoodResultModelObservable()
        bindQueryUseCase()
        bindTargetSugarData()
    }
    
    private func bindFoodResultModelObservable() {
        searchFoodUseCase.foodResultModelObservable
            .subscribe(onNext: { [weak self] searchFoodViewModel in
                if self?.scopeState == .searchResult {
                    self?.currentFoodViewModels = searchFoodViewModel
                    self?.updateSearchResult()
                } else if self?.scopeState == .favorites {
                    self?.updateFavoriteResult()
                }
                self?.loading.accept(.finishLoading)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindQueryUseCase() {
        manageQueryUseCase.queryObservable
            .map({ $0.reversed() })
            .subscribe(onNext: { [weak self] query in
                self?.searchQueryObservable.accept(query)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTargetSugarData() {
        fetchProfileUseCase.profileDataSubject
            .subscribe(onNext: { [weak self] profileData in
                self?.targetSugarRelay.accept(Double(profileData.sugarLevel))
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Input
    var currentKeyword: String = ""
    
    func fetchTargetSugarData() {
        fetchProfileUseCase.fetchProfileData()
    }
    
    func cancelButtonTapped() {
        currentFoodViewModels = []
        searchFoodViewModelObservable.accept(currentFoodViewModels)
    }
    
    func changeFavorite(indexPath: IndexPath?,
                        foodModel: FoodViewModel?) {
        if indexPath != nil {
            if scopeState == .searchResult {
                changeFavoriteUseCase.changeFavorite(food: FoodDomainModel.init(currentFoodViewModels[indexPath!.row]))
                self.searchFoodUseCase.updateViewModel(keyword: nil)
                
            } else {
                changeFavoriteUseCase.changeFavorite(food: FoodDomainModel.init(favoriteFoodViewModels[indexPath!.row]))
                self.favoriteFoodViewModels = self.fetchFavoriteFoodsUseCase.fetchFavoriteFoods()
                self.searchFoodUseCase.updateViewModel(keyword: nil)
                self.updateFavoriteResult()
            }
        } else if foodModel != nil {
            if scopeState == .searchResult {
                changeFavoriteUseCase.changeFavorite(food: FoodDomainModel.init(foodModel!))
                self.searchFoodUseCase.updateViewModel(keyword: nil)
            } else {
                changeFavoriteUseCase.changeFavorite(food: FoodDomainModel.init(foodModel!))
                self.favoriteFoodViewModels = self.fetchFavoriteFoodsUseCase.fetchFavoriteFoods()
                self.searchFoodUseCase.updateViewModel(keyword: nil)
                self.updateFavoriteResult()                
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
    var searchFoodViewModelObservable = PublishRelay<[FoodViewModel]>()
    var searchQueryObservable = PublishRelay<[String]>()
    let loading = PublishRelay<LoadingState>()
    enum LoadingState {
        case startLoading
        case finishLoading
    }
    
    func updateRecentQuery() {
        manageQueryUseCase.updateQuery()
    }
    
    //MARK: - Private
    private var currentFoodViewModels: [FoodViewModel] = []
    private var favoriteFoodViewModels: [FoodViewModel] = []
    private var scopeState: SearchBarScopeState = .searchResult
    
    
    enum SearchBarScopeState {
        case searchResult
        case favorites
        case query
    }
    private func startSearching(searchBarText: String) {
        manageQueryUseCase.addQueryOnCoreData(keyword: searchBarText)
        searchFoodUseCase.fetchFood(text: searchBarText)
        loading.accept(.startLoading)
    }
    
    private func changeToFavoriteFoods() {
        favoriteFoodViewModels = fetchFavoriteFoodsUseCase.fetchFavoriteFoods()
        searchFoodViewModelObservable.accept(favoriteFoodViewModels)
    }
    
    private func updateSearchResult() {
        scopeState = .searchResult
        searchFoodViewModelObservable.accept(currentFoodViewModels)
    }
    
    private func updateFavoriteResult() {
        searchFoodViewModelObservable.accept(favoriteFoodViewModels)
    }
    
    private func compareFavoriteResult(text: String) {
        guard text != "" else { return updateFavoriteResult() }
        let filteredViewModel = favoriteFoodViewModels.filter {(model: FoodViewModel) -> Bool in
            return model.name!.contains(text)
        }
        searchFoodViewModelObservable.accept(filteredViewModel)
    }
}

