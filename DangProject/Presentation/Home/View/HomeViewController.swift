//
//  ViewController.swift
//  DangProject
//
//  Created by 김동우 on 2021/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import CoreGraphics
import Then

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel?
    weak var coordinator: Coordinator?
    var disposeBag = DisposeBag()
    var mainCollectionView: UICollectionViewController = {
        let layout = UICollectionViewLayout()
        let collectionViewController = UICollectionViewController(collectionViewLayout: layout)
        
        return collectionViewController
    }()
    var graphView = GraphView()
    
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
        configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(coordinator)
    }
    
    func configure() {
        [ graphView ].forEach() { view.addSubview($0) }
        
        graphView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
//            $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 200).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }
    }
}

