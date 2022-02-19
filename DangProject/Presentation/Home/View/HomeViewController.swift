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
import CloudKit

class HomeViewController: UIViewController {
    var viewModel: HomeViewModel?
    weak var coordinator: Coordinator?
    private var disposeBag = DisposeBag()
    private var customNavigationBar = CustomNavigationBar()
    private var homeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.do {
            $0.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        
        return collectionView
    }()
    private var heightAnchor: NSLayoutConstraint?
    private var firstContentY: CGFloat = 0
    private var batteryCellHeight: CGFloat?
    
    static func create(viewModel: HomeViewModel,
                       coordinator: Coordinator) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        
        return viewController
    }
    private var barHeight: CGFloat = 90
    private let gradient = CAGradientLayer()
    private let newColors = [
        UIColor.systemRed.cgColor,
        UIColor.orange.cgColor,
        UIColor.systemYellow.cgColor
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        configure()
        layout()
        view.bringSubviewToFront(customNavigationBar)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(coordinator)
    }

    
    
    private func configure() {
        gradient.do {
            $0.frame = homeCollectionView.frame
            $0.colors = newColors
        }
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
            $0.register(HomeCollectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeCollectionFooter.identfier)
            $0.dataSource = self
            $0.delegate = self
            $0.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func layout() {
        [ customNavigationBar, homeCollectionView ].forEach() { view.addSubview($0) }
        
        customNavigationBar.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor = $0.heightAnchor.constraint(equalToConstant: 110)
            heightAnchor?.isActive = true
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
            
            if let viewModel = viewModel?.sumData.value {
                let batteryViewModel = BatteryCellViewModel(item: viewModel)
                batteryCell.bind(viewModel: batteryViewModel)
            }
            
            return batteryCell
        case 1:
            guard let ateFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: AteFoodCell.identifier, for: indexPath) as? AteFoodCell else { return UICollectionViewCell() }
            if let viewModel = viewModel?.tempData.value {
                let ateViewModel = AteFoodItemViewModel(item: viewModel)
                ateFoodCell.bind(viewModel: ateViewModel)
            }
            return ateFoodCell
        case 2:
            guard let graphCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGraphCell.identifier,
                                                                     for: indexPath) as? HomeGraphCell else { return UICollectionViewCell() }
            if let viewModelItem = viewModel?.weekData.value {
                let viewModel = GraphItemViewModel(item: viewModelItem)
                graphCell.bind(viewModel: viewModel)
                
            }
            return graphCell
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
                                                                       withReuseIdentifier: AteFoodHeader.identifier,
                                                                       for: indexPath)
            }
            return UICollectionReusableView()
        case 2:
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: GraphCellHeader.identifier,
                                                                       for: indexPath)
            }
            if kind == UICollectionView.elementKindSectionFooter {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: HomeCollectionFooter.identfier,
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize()
        case 1:
            return CGSize()
        case 2:
            return CGSize(width: UIScreen.main.bounds.maxX, height: 200)
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
            return CGSize(width: self.homeCollectionView.frame.maxX-2,
                          height: UIScreen.main.bounds.maxY/2)
        case 1:
            return CGSize(width: self.homeCollectionView.frame.maxX-20,
                          height: 90)
        case 2:
            return CGSize(width: self.homeCollectionView.frame.maxX-20,
                          height: 340)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 30
        case 2:
            return 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 30
        case 2:
            return 0
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension HomeViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        firstContentY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let secondContentY = scrollView.contentOffset.y
        let finalContentY = secondContentY - firstContentY
        fixHomeCollectionView(contentY: secondContentY)
        hideCustomNavigationBar(contentY: finalContentY)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        let secondContentY = scrollView.contentOffset.y
        let finalContentY = secondContentY - firstContentY
        if finalContentY > 45 {
            animationCustomNavigationViewUp(contentY: finalContentY)
        } else {
            animationCustomNavigationViewDown()
        }
    }
}

extension HomeViewController {
    private func isAnimateNavigationBar(view: UIView) -> Bool {
        let rect = CGRect(x: 0,
                          y: -90,
                          width: UIScreen.main.bounds.maxX,
                          height: 90)
        if view.frame == rect {
            return true
        }
        return false
    }
    
    private func fixHomeCollectionView(contentY: CGFloat) {
        if contentY < 0 {
            homeCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        } else {
            homeCollectionView.isScrollEnabled = true
        }
    }
    
    private func hideCustomNavigationBar(contentY: CGFloat) {
        if contentY >= 0 {
            hideNavigationBarScrollDown(contentY: contentY)
        } else {
            showNavigationBarScrollUp()
        }
    }
    
    private func hideNavigationBarScrollDown(contentY: CGFloat) {
        if contentY < 90 && isAnimateNavigationBar(view: customNavigationBar) == false {
            customNavigationBar.frame = CGRect(x: 0,
                                               y: -contentY,
                                               width: UIScreen.main.bounds.maxX,
                                               height: 90)
            customNavigationBar.profileImageView.alpha = (90-contentY)/90
        } else {
            customNavigationBar.frame = CGRect(x: 0,
                                               y: -90,
                                               width: UIScreen.main.bounds.maxX,
                                               height: 90)
            customNavigationBar.profileImageView.isHidden = true
        }
    }
    
    private func showNavigationBarScrollUp() {
        self.customNavigationBar.profileImageView.isHidden = false
        customNavigationBar.setNavigationBarReturnAnimation()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.customNavigationBar.profileImageView.alpha = 1.0
            self?.customNavigationBar.layoutIfNeeded()
            self?.customNavigationBar.frame = CGRect(x: 0,
                                                     y: 0,
                                                     width: UIScreen.main.bounds.maxX,
                                                     height: 90)
        }
    }
    
    private func animationCustomNavigationViewUp(contentY: CGFloat) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.customNavigationBar.frame = CGRect(x: 0,
                                               y: -90,
                                               width: UIScreen.main.bounds.maxX,
                                               height: 90)
            self?.customNavigationBar.profileImageView.alpha = (90-contentY)/90
        }
        self.customNavigationBar.profileImageView.isHidden = true
    }
    
    private func animationCustomNavigationViewDown() {
        self.customNavigationBar.profileImageView.isHidden = false
        customNavigationBar.setNavigationBarReturnAnimation()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.customNavigationBar.profileImageView.alpha = 1.0
            self?.customNavigationBar.layoutIfNeeded()
            self?.customNavigationBar.frame = CGRect(x: 0,
                                                     y: 0,
                                                     width: UIScreen.main.bounds.maxX,
                                                     height: 90)
        }
    }
}
