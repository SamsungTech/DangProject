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
    let searchResultTableView = UITableView()
    
    let disposeBag = DisposeBag()
    // MARK: - Init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpBindings()
        
        

    }
    // MARK: - Set Views
    func setUpViews() {
        setUpBackGround()
        setUpSearchController()
        setUpSearchResultTableView()
    }
    
    func setUpBackGround() {
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    func setUpSearchController() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = viewModel.navigationItemTitle
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = viewModel.searchBarPlaceHolder
        searchController.searchBar.scopeButtonTitles = viewModel.searchBarScopeButtonTitles
        searchController.searchBar.delegate = self
    }
    func setUpSearchResultTableView() {
        view.addSubview(searchResultTableView)
        searchResultTableView.translatesAutoresizingMaskIntoConstraints = false
        searchResultTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchResultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchResultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchResultTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchResultTableView.backgroundColor = .white
        searchResultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "Cell")
        searchResultTableView.isHidden = true
    }
    
    // MARK: - Set Binding (RxSwift)
    func setUpBindings() {
        bindTableView()
        bindSearchBar()
        bindLoading()
    }
    
    func bindTableView() {
        viewModel.searchFoodViewModelObservable
            .map({ $0.foodModels!})
            .bind(to: searchResultTableView.rx.items(cellIdentifier: "Cell", cellType: SearchResultTableViewCell.self)) {index, item, cell in
                cell.cellDelegation = self
                cell.titleLabel.text = item.name
            }
            .disposed(by: disposeBag)
        
        searchResultTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        searchResultTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.searchResultTableView.deselectRow(at: indexPath, animated: false)
                
                //                guard let selectedFood = self?.viewModel.findFood(indexPath: indexPath) else { return }
                //
                //                self?.coordinator?.pushDetailFoodView(food: selectedFood)
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindSearchBar() {
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ !$0.isEmpty })
            .subscribe(onNext: { [unowned self] text in
                viewModel.startSearching(food: text)
            })
            .disposed(by: disposeBag)
    }
    
    func bindLoading() {
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
extension SearchViewController: UITableViewDelegate {}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchResultTableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultTableView.isHidden = true
        viewModel.cancelButtonTapped()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        viewModel.searchFoodViewModelObservable.dispose()
        LoadingView.hideLoading()
    }
}
extension SearchViewController: TableViewCellDelegate {
    func favoriteButtonTapped(cell: UITableViewCell) {
        let cellIndexpath = searchResultTableView.indexPath(for: cell)!
        viewModel.changeFavorite(indexPath: cellIndexpath)
    }
}
