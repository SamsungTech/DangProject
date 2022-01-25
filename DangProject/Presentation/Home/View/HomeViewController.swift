//
//  ViewController.swift
//  DangProject
//
//  Created by 김동우 on 2021/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel?
    weak var coordinator: Coordinator?
    var disposeBag = DisposeBag()
    var customNavigationBar = CustomNavigationBar()
    var homeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.do {
            $0.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        
        return collectionView
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
        viewModel?.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        configure()
        layout()
        view.bringSubviewToFront(customNavigationBar)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(coordinator)
    }
    
    func configure() {
        homeCollectionView.do {
            $0.register(BatteryCell.self, forCellWithReuseIdentifier: BatteryCell.identifier)
            $0.register(GraphCellHeader.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: GraphCellHeader.identifier)
            $0.register(HomeGraphCell.self, forCellWithReuseIdentifier: HomeGraphCell.identifier)
            $0.register(AteFoodHeader.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: AteFoodHeader.identifier)
            $0.register(AteFoodCell.self, forCellWithReuseIdentifier: AteFoodCell.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
    }
    
    func layout() {
        [ customNavigationBar, homeCollectionView ].forEach() { view.addSubview($0) }
        
        customNavigationBar.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: viewXRatio(90)).isActive = true
        }
        homeCollectionView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let batteryCell = collectionView.dequeueReusableCell(withReuseIdentifier: BatteryCell.identifier, for: indexPath) as? BatteryCell else { return UICollectionViewCell() }
            return batteryCell
        case 1:
            guard let graphCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGraphCell.identifier,
                                                                     for: indexPath) as? HomeGraphCell else { return UICollectionViewCell() }
            return graphCell
        case 2:
            guard let ateFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: AteFoodCell.identifier, for: indexPath) as? AteFoodCell else { return UICollectionViewCell() }
            
            return ateFoodCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            return UICollectionReusableView()
        case 1:
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: GraphCellHeader.identifier,
                                                                             for: indexPath)
            }
            return UICollectionReusableView()
        case 2:
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: AteFoodHeader.identifier,
                                                                             for: indexPath)
            }
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize()
        case 1:
            return CGSize(width: view.frame.size.width,
                          height: 30)
        case 2:
            return CGSize(width: view.frame.size.width,
                          height: 30)
        default:
            return CGSize()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: self.homeCollectionView.frame.maxX-20,
                          height: self.homeCollectionView.frame.maxY-20)
        case 1:
            return CGSize(width: self.homeCollectionView.frame.maxX-20,
                          height: 200)
        case 2:
            return CGSize(width: self.homeCollectionView.frame.maxX-20,
                          height: 200)
        default:
            return CGSize()
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}

extension HomeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            customNavigationBar.setNavigationBarAnimation()
        } else {
            customNavigationBar.setNavigationBarReturnAnimation()
        }
    }
}
