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
    private var heightAnchor: NSLayoutConstraint?
    private var firstContentY: CGFloat = 0
    private var batteryCellHeight: CGFloat?
    private var barHeight: CGFloat = 90
    private let gradient = CAGradientLayer()
    private let newColors = [
        UIColor.systemRed.cgColor,
        UIColor.orange.cgColor,
        UIColor.systemYellow.cgColor
    ]
    private var homeScrollView = UIScrollView()
    private var homeStackView = UIStackView()
    private var viewsInStackView: [UIView] = []
    var batteryView = BatteryView()
    var ateFoodView = AteFoodView()
    var homeGraphView = HomeGraphView()
    var heightAnchor1: NSLayoutConstraint?
    
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
    
    private func configure() {
        homeScrollView.do {
            $0.backgroundColor = .systemGreen
            $0.showsVerticalScrollIndicator = true
            $0.contentSize = CGSize(width: UIScreen.main.bounds.maxX, height: 2000)
            $0.contentInsetAdjustmentBehavior = .never
            $0.bounces = false
        }
        homeStackView.do {
            $0.axis = .vertical
            $0.spacing = 50
            $0.backgroundColor = .blue
            $0.distribution = .fill
            $0.alignment = .center
        }
    }
    
    private func layout() {
        [ customNavigationBar, homeScrollView ].forEach() { view.addSubview($0) }
        [ homeStackView ].forEach() { homeScrollView.addSubview($0) }
        [ batteryView, ateFoodView, homeGraphView ].forEach() { viewsInStackView.append($0) }
        viewsInStackView.forEach() { homeStackView.addArrangedSubview($0) }
        
        customNavigationBar.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor = $0.heightAnchor.constraint(equalToConstant: 110)
            heightAnchor?.isActive = true
        }
        homeScrollView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        homeStackView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: homeScrollView.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        batteryView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
            heightAnchor1 = batteryView.heightAnchor.constraint(equalToConstant: 500)
            heightAnchor1?.isActive = true
        }
        ateFoodView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX-40).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        homeGraphView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX-40).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }
        customNavigationBar.yearMouthButton.rx.tap
            .bind {
                self.animation()
            }
            .disposed(by: disposeBag)
        bind()
    }
    
    private func bind() {
        if let viewModel = viewModel?.sumData.value {
            let batteryViewModel = BatteryCellViewModel(item: viewModel)
            batteryView.bind(viewModel: batteryViewModel)
        }
        
        if let viewModel = viewModel?.tempData.value {
            let ateFoodViewModel = AteFoodItemViewModel(item: viewModel)
            ateFoodView.bind(viewModel: ateFoodViewModel)
        }
        
        if let viewModel = viewModel?.weekData.value {
            let homeGraphViewModel = GraphItemViewModel(item: viewModel)
            homeGraphView.bind(viewModel: homeGraphViewModel)
        }
    }
    
    
    private func animation() {
        heightAnchor1?.constant = UIScreen.main.bounds.maxY
        UIView.animate(withDuration: 3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension HomeViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        firstContentY = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let secondContentY = scrollView.contentOffset.y
        let finalContentY = secondContentY - firstContentY
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
