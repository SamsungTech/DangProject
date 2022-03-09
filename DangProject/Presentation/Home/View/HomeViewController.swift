//
//  ViewController.swift
//  DangProject
//
//  Created by 김동우 on 2021/12/20.
//

import Then
import UIKit

import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    var viewModel: HomeViewModel?
    private weak var coordinator: Coordinator?
    private var disposeBag = DisposeBag()
    private var customNavigationBar = CustomNavigationBar()
    private var batteryView = BatteryView()
    private let ateFoodTitleView = AteFoodTitleView()
    private var ateFoodView = AteFoodView()
    private let graphTitleView = GraphTitleView()
    private var homeGraphView = HomeGraphView()
    private var heightAnchor: NSLayoutConstraint?
    private var batteryViewHeightAnchor: NSLayoutConstraint?
    private var firstContentY: CGFloat = 0
    private var homeScrollView = UIScrollView()
    private var homeStackView = UIStackView()
    private var viewsInStackView: [UIView] = []
    private var isExpandBatteryView = false
    private var currentCGPoint = CGPoint()
    private var currentLineNumber = 0
    
    static func create(viewModel: HomeViewModel,
                       coordinator: Coordinator) -> HomeViewController {
        let viewController = HomeViewController()
        
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        bindCurrentLineNumber()
        viewModel?.viewDidLoad()
        configure()
        layout()
        bind()
        view.layoutIfNeeded()
        view.bringSubviewToFront(customNavigationBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let centerPoint = CGPoint(x: UIScreen.main.bounds.maxX, y: .zero)
        batteryView.calendarCollectionView.setContentOffset(centerPoint, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(coordinator)
    }
    
    private func configure() {
        homeScrollView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = true
            $0.contentSize = CGSize(width: UIScreen.main.bounds.maxX, height: overSizeYValueRatio(1200))
            $0.contentInsetAdjustmentBehavior = .automatic
            $0.bounces = false
        }
        homeStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.backgroundColor = .clear
            $0.distribution = .fill
            $0.alignment = .center
        }
        batteryView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = xValueRatio(30)
        }
    }
    
    private func layout() {
        [ customNavigationBar, homeScrollView ].forEach() { view.addSubview($0) }
        [ homeStackView ].forEach() { homeScrollView.addSubview($0) }
        [ batteryView, ateFoodTitleView, ateFoodView,
          graphTitleView, homeGraphView ].forEach() { viewsInStackView.append($0) }
        
        viewsInStackView.forEach() { homeStackView.addArrangedSubview($0) }
        
        customNavigationBar.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: batteryView.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor = $0.heightAnchor.constraint(equalToConstant: yValueRatio(110))
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
            $0.topAnchor.constraint(equalTo: homeScrollView.topAnchor, constant: yValueRatio(-47)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        batteryView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
            batteryViewHeightAnchor = batteryView.heightAnchor.constraint(equalToConstant: yValueRatio(500))
            batteryViewHeightAnchor?.isActive = true
            $0.calendarViewTopAnchor?.constant = yValueRatio(CGFloat(110-(60*currentLineNumber)))
        }
        ateFoodTitleView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
            $0.heightAnchor.constraint(equalToConstant: yValueRatio(50)).isActive = true
        }
        ateFoodView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
            $0.heightAnchor.constraint(equalToConstant: yValueRatio(100)).isActive = true
        }
        graphTitleView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
            $0.heightAnchor.constraint(equalToConstant: yValueRatio(50)).isActive = true
        }
        homeGraphView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX-yValueRatio(40)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: yValueRatio(300)).isActive = true
        }
    }
}

extension HomeViewController {
    private func bind() {
        batteryView.bind(homeViewController: self)
        
        viewModel?.tempData
            .subscribe(onNext: { [weak self] data in
                let ateFoodViewModel = AteFoodViewModel(item: data)
                self?.ateFoodView.bind(viewModel: ateFoodViewModel)
            })
            .disposed(by: disposeBag)
        
        viewModel?.weekData
            .subscribe(onNext: { [weak self] data in
                let homeGraphViewModel = GraphViewModel(item: data)
                self?.homeGraphView.bind(viewModel: homeGraphViewModel)
            })
            .disposed(by: disposeBag)
        
        viewModel?.currentXPoint
            .subscribe(onNext: { [weak self] data in
                if let text = self?.viewModel?.retriveBatteryData().calendar?[data].yearMouth {
                    self?.customNavigationBar.dateLabel.text = text
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.currentDateCGPoint
            .subscribe(onNext: { [weak self] data in
                self?.currentCGPoint = data
            })
            .disposed(by: disposeBag)
        
        customNavigationBar.yearMouthButton.rx.tap
            .bind { [weak self] _ in
                self?.batteryAnimation()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCurrentLineNumber() {
        viewModel?.currentLineNumber
            .subscribe(onNext: { [weak self] data in
                self?.currentLineNumber = data
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func batteryAnimation() {
        if isExpandBatteryView == false {
            expandAnimation()
        } else {
            revertAnimation()
        }
    }
    
    private func expandAnimation() {
        batteryView.calendarViewTopAnchor?.constant = yValueRatio(110)
        batteryView.circleProgressBarTopAnchor?.constant = yValueRatio(470)
        batteryViewHeightAnchor?.constant = UIScreen.main.bounds.maxY
        homeScrollView.contentSize = CGSize(width: UIScreen.main.bounds.maxX,
                                            height: overSizeYValueRatio(1544))
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        homeScrollView.isScrollEnabled = false
        isExpandBatteryView = true
    }
    
    private func revertAnimation() {
        viewModel?.calculateCurrentDatePoint()
        batteryView.calendarViewTopAnchor?.constant = yValueRatio(CGFloat(110-(60*currentLineNumber)))
        batteryView.circleProgressBarTopAnchor?.constant = yValueRatio(170)
        batteryViewHeightAnchor?.constant = yValueRatio(500)
        
        homeScrollView.contentSize = CGSize(width: UIScreen.main.bounds.maxX,
                                            height: overSizeYValueRatio(1200))
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let currentCGPoint = self?.currentCGPoint else { return }
            self?.batteryView.calendarCollectionView.setContentOffset(currentCGPoint, animated: true)
        })
        homeScrollView.isScrollEnabled = true
        isExpandBatteryView = false
    }
}
