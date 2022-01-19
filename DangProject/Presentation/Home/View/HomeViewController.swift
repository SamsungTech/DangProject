//
//  ViewController.swift
//  DangProject
//
//  Created by 김동우 on 2021/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel?
    weak var coordinator: Coordinator?
    var disposeBag = DisposeBag()
    var mainCollectionView: UICollectionViewController = {
        let layout = UICollectionViewLayout()
        let collectionViewController = UICollectionViewController(collectionViewLayout: layout)
        
        return collectionViewController
    }()
    
    static func create(viewModel: HomeViewModel,
                       coordinator: Coordinator) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(coordinator)
    }
    
    
}

