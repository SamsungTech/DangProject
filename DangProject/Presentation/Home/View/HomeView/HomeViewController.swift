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

protocol HomeViewControllerProtocol: AnyObject {
    func resetBatteryViewConfigure()
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {
    private weak var coordinator: Coordinator?
    private var disposeBag = DisposeBag()
    private var customNavigationBar = CustomNavigationBar()
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
    private var currentCGPoint: CGPoint = .zero
    private var selectedDayYValue: CGFloat = 0
    private var selectedCellEntity: SelectedCellEntity = .empty
    var viewModel: HomeViewModel?
    var batteryView = BatteryView()
    
    static func create(viewModel: HomeViewModel,
                       coordinator: Coordinator) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        viewModel.homeViewController = viewController
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .homeBackgroundColor
        viewModel?.viewDidLoad()
        bindCurrentLineNumber()
        configure()
        layout()
        subscribe()
        view.bringSubviewToFront(customNavigationBar)
        configureBatteryView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        batteryView.calendarCollectionView.scrollToItem(at: .init(item: 1, section: 0),
                                                        at: .centeredHorizontally,
                                                        animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(coordinator)
    }
    
    private func configureBatteryView() {
        batteryView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = xValueRatio(30)
            $0.calendarCollectionView.isScrollEnabled = false
            $0.animateShapeLayer(selectedCellEntity.circleDangValue,
                                 selectedCellEntity.circleAnimationDuration)
            $0.countAnimation(selectedCellEntity.circlePercentValue)
            $0.targetSugar.text = "목표: " + selectedCellEntity.selectedDangValue + "/"
            + selectedCellEntity.selectedMaxDangValue
        }
    }
    
    private func configure() {
        homeScrollView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = true
            $0.contentSize = CGSize(width: UIScreen.main.bounds.maxX,
                                    height: overSizeYValueRatio(1200))
            $0.contentInsetAdjustmentBehavior = .automatic
            $0.bounces = false
            $0.contentInsetAdjustmentBehavior = .never
        }
        homeStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.backgroundColor = .homeBackgroundColor
            $0.distribution = .fill
            $0.alignment = .center
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
            $0.topAnchor.constraint(equalTo: homeScrollView.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        batteryView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
            batteryViewHeightAnchor = batteryView.heightAnchor.constraint(equalToConstant: yValueRatio(500))
            batteryViewHeightAnchor?.isActive = true
            $0.calendarViewTopAnchor?.constant = selectedDayYValue
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
    private func subscribe() {
        bindBatteryViewModel()
        bindAteFoodViewModel()
        bindHomeGraphViewModel()
        bindCurrentDayPointData()
        bindCalendarScaleAnimation()
        bindSelectedCellViewData()
    }
    
    private func bindBatteryViewModel() {
        guard let viewModel = self.viewModel else { return }
        batteryView.bind(viewModel: viewModel)
    }
    
    private func bindAteFoodViewModel() {
        viewModel?.tempData
            .subscribe(onNext: { [weak self] in
                let ateFoodViewModel = AteFoodViewModel(item: $0)
                self?.ateFoodView.bind(viewModel: ateFoodViewModel)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindHomeGraphViewModel() {
        viewModel?.weekData
            .subscribe(onNext: { [weak self] in
                let homeGraphViewModel = GraphViewModel(item: $0)
                self?.homeGraphView.bind(viewModel: homeGraphViewModel)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCurrentDayPointData() {
        viewModel?.currentXPoint
            .subscribe(onNext: { [weak self] in
                if let text = self?.viewModel?.batteryViewCalendarData.value[$0].yearMonth {
                    self?.customNavigationBar.dateLabel.text = text
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.currentDateCGPoint
            .subscribe(onNext: { [weak self] in
                self?.currentCGPoint = $0
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCalendarScaleAnimation() {
        customNavigationBar.yearMouthButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.calculateCalendarScaleState()
            }
            .disposed(by: disposeBag)
        
        viewModel?.calendarScaleAnimation
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .expand:
                    self?.expandAnimation()
                case .revert:
                    self?.revertAnimation()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSelectedCellViewData() {
        viewModel?.selectedCellViewData
            .subscribe(onNext: { [weak self] in
                self?.selectedCellEntity = $0
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCurrentLineNumber() {
        viewModel?.currentLineYValue
            .subscribe(onNext: { [weak self] in
                self?.selectedDayYValue = $0
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    func resetBatteryViewConfigure() {
        batteryView.do {
            $0.animateShapeLayer(selectedCellEntity.circleDangValue,
                                 selectedCellEntity.circleAnimationDuration)
            $0.countAnimation(selectedCellEntity.circlePercentValue)
            $0.targetSugar.text = "목표: " + selectedCellEntity.selectedDangValue + "/" + selectedCellEntity.selectedMaxDangValue
            $0.animationLineLayer.strokeColor = selectedCellEntity.selectedCircleColor
            $0.percentLineBackgroundLayer.strokeColor = selectedCellEntity.selectedCircleBackgroundColor
            $0.percentLineLayer.strokeColor = selectedCellEntity.selectedAnimationLineColor
        }
    }
    
    private func expandAnimation() {
        batteryView.calendarCollectionView.isScrollEnabled = true
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
        viewModel?.calculateSelectedDayXPoint()
        batteryView.calendarViewTopAnchor?.constant = selectedDayYValue
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
        batteryView.calendarCollectionView.isScrollEnabled = false
    }
}
