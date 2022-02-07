//
//  SearchFoodViewController.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/03.
//

import Foundation
import UIKit

import RxSwift

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    weak var coordinator: SearchCoordinator?
    
    let viewModel: SearchViewModel
    let searchController = UISearchController(searchResultsController: nil)
    let searchResultTableView = UITableView()
    
    let disposeBag = DisposeBag()
    
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
        
    }
    
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
}

