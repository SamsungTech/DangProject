//
//  SearchFoodViewController.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/03.
//
import Foundation
import UIKit

import RxCocoa
import RxSwift

class SearchViewController: UIViewController {
    
    weak var coordinator: SearchCoordinator?
    
    let viewModel: SearchViewModel
    let searchController = UISearchController(searchResultsController: nil)
    let queryResultTableView = UITableView()
    let searchResultTableView = UITableView()
    let recentSearchLabel = UILabel()
    let eraseAllQueryButton = UIButton()
    let addCompleteToastLabel = UILabel()
    var addCompleteLabelTopConstraint = NSLayoutConstraint()
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setUpBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDefaultView()
        setUpSearchingPreferenceViews()
        
    }
    // MARK: - Set Views
    private func setUpDefaultView() {
        setUpBackground()
        setUpRecentLabel()
        setUpQueryResultTableView()
        setUpEraseAllQueryButton()
    }
    
    private func setUpBackground() {
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    private func setUpRecentLabel() {
        view.addSubview(recentSearchLabel)
        recentSearchLabel.translatesAutoresizingMaskIntoConstraints = false
        recentSearchLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        recentSearchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        recentSearchLabel.text = "최근검색어"
        recentSearchLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    }
    
    private func setUpQueryResultTableView() {
        view.addSubview(queryResultTableView)
        queryResultTableView.translatesAutoresizingMaskIntoConstraints = false
        queryResultTableView.topAnchor.constraint(equalTo: recentSearchLabel.bottomAnchor, constant: 5).isActive = true
        queryResultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        queryResultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        queryResultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        queryResultTableView.register(QueryTableViewCell.self,
                                      forCellReuseIdentifier: QueryTableViewCell.identifier)
        queryResultTableView.backgroundColor = .systemGray6
        queryResultTableView.roundCorners(cornerRadius: 15)
    }
    
    private func setUpEraseAllQueryButton() {
        view.addSubview(eraseAllQueryButton)
        eraseAllQueryButton.translatesAutoresizingMaskIntoConstraints = false
        eraseAllQueryButton.bottomAnchor.constraint(equalTo: queryResultTableView.topAnchor, constant: 1).isActive = true
        eraseAllQueryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        eraseAllQueryButton.setTitle("모두지우기", for: .normal)
        eraseAllQueryButton.setTitleColor(.systemBlue, for: .normal)
        eraseAllQueryButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        eraseAllQueryButton.addTarget(self,
                                      action: #selector(eraseAllQueryButtonTapped),
                                      for: .touchUpInside)
    }
    
    @objc private func eraseAllQueryButtonTapped() {
        viewModel.eraseQueryResult()
    }
    
    private func setUpSearchingPreferenceViews() {
        setUpSearchController()
        setUpSearchResultTableView()
        setUpAddCompleteToastLabel()
    }
    
    private func setUpSearchController() {
        navigationItem.searchController = searchController
        navigationItem.title = "음식 추가"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "음식을 검색하세요."
        searchController.searchBar.scopeButtonTitles = ["검색결과", "즐겨찾기"]
        searchController.searchBar.delegate = self
    }
    
    private func setUpSearchResultTableView() {
        view.addSubview(searchResultTableView)
        searchResultTableView.translatesAutoresizingMaskIntoConstraints = false
        searchResultTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchResultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchResultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchResultTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchResultTableView.backgroundColor = .white
        searchResultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        searchResultTableView.isHidden = true
        searchResultTableView.keyboardDismissMode = .onDrag
    }
    
    private func setUpAddCompleteToastLabel() {
        searchResultTableView.addSubview(addCompleteToastLabel)
        view.bringSubviewToFront(addCompleteToastLabel)
        addCompleteToastLabel.translatesAutoresizingMaskIntoConstraints = false
        addCompleteLabelTopConstraint = addCompleteToastLabel.topAnchor.constraint(equalTo: view.bottomAnchor)
        addCompleteLabelTopConstraint.isActive = true
        addCompleteToastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        addCompleteToastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        addCompleteToastLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addCompleteToastLabel.backgroundColor = .systemBlue
        addCompleteToastLabel.textAlignment = .center
        addCompleteToastLabel.textColor = .white
        addCompleteToastLabel.roundCorners(cornerRadius: 15)
        addCompleteToastLabel.numberOfLines = 0
        addCompleteToastLabel.alpha = 0.8

    }
    
    func addCompleteLabelAnimation(name: String, amount: String) {
        addCompleteToastLabel.text = "\(name) \(amount)개가 추가됐습니다."
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut, animations: { [unowned self] in
            addCompleteLabelTopConstraint.isActive = false
            addCompleteLabelTopConstraint = addCompleteToastLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
            addCompleteLabelTopConstraint.isActive = true
            view.layoutIfNeeded()
        }, completion: { _ in
            self.popAddCompleteToastLabel()
        })
    }
    
    private func popAddCompleteToastLabel() {
        UIView.animate(withDuration: 0.5,
                       delay: 2.5,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut, animations: { [unowned self] in
            self.addCompleteLabelTopConstraint.isActive = false
            self.addCompleteLabelTopConstraint = addCompleteToastLabel.topAnchor.constraint(equalTo: view.bottomAnchor)
            self.addCompleteLabelTopConstraint.isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Set Binding (RxSwift)
    private func setUpBindings() {
        bindSearchResultTableView()
        bindLoading()
        bindQueryTableView()
    }
    
    private func bindSearchResultTableView() {
        viewModel.searchFoodViewModelObservable
            .observe(on: MainScheduler.instance)
            .map({ $0.foodModels! })
            .bind(to: searchResultTableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier,
                                                     cellType: SearchResultTableViewCell.self)) {index, item, cell in
                cell.cellDelegation = self
                cell.bindTableViewCell(item: item)
            }
            .disposed(by: disposeBag)
        
        searchResultTableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.searchResultTableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
        
        searchResultTableView.rx
            .modelSelected(FoodViewModel.self)
            .subscribe(onNext: { [weak self] food in
                self?.coordinator?.pushDetailFoodView(food: food, from: self!)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindQueryTableView() {
        viewModel.searchQueryObservable
            .observe(on: MainScheduler.instance)
            .bind(to: queryResultTableView.rx.items(cellIdentifier: QueryTableViewCell.identifier,
                                                    cellType: QueryTableViewCell.self)) {index, item, cell in
                cell.bindTextLabel(name: item)
            }
            .disposed(by: disposeBag)
        
        queryResultTableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.queryResultTableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
        
        queryResultTableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { [weak self] keyword in
                self?.searchController.searchBar.text = keyword
                self?.viewModel.searchBarTextDidChanged(text: keyword)
            })
            .disposed(by: disposeBag)
        
        viewModel.updateRecentQuery()
    }
    
    private func bindSearchBar() {
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ !$0.isEmpty })
            .subscribe(onNext: { [unowned self] text in
                viewModel.searchBarTextDidChanged(text: text)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindLoading() {
        viewModel.loading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in
                switch state {
                case .startLoading:
                    searchResultTableView.isHidden = true
                    LoadingView.showLoading()
                case .finishLoading:
                    searchResultTableView.isHidden = false
                    LoadingView.hideLoading()
                }
            })
            .disposed(by: disposeBag)
    }
    
}
// MARK: - Extension

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResultTableView.isHidden = false
        recentSearchLabel.isHidden = true
        queryResultTableView.isHidden = true
        eraseAllQueryButton.isHidden = true
        bindSearchBar()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultTableView.isHidden = true
        viewModel.cancelButtonTapped()
        recentSearchLabel.isHidden = false
        queryResultTableView.isHidden = false
        eraseAllQueryButton.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        LoadingView.hideLoading()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel.selectedScopeDidChanged(to: selectedScope)
    }
}
extension SearchViewController: TableViewCellDelegate {
    func favoriteButtonTapped(cell: UITableViewCell) {
        let cellIndexPath = searchResultTableView.indexPath(for: cell)!
        viewModel.changeFavorite(indexPath: cellIndexPath, foodModel: nil)
    }
}

extension SearchViewController: DetailFoodParentable {
    func addFoodsAfter(food: AddFoodsViewModel) {
        addCompleteLabelAnimation(name: (food.foodModel?.name)!, amount: String(food.amount))
    }
    
    func favoriteTapped(foodModel: FoodViewModel) {
        viewModel.changeFavorite(indexPath: nil, foodModel: foodModel)
    }
}
