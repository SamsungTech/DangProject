//
//  ViewController.swift
//  DangProject
//
//  Created by 김동우 on 2021/12/20.
//

import UIKit

import RxCocoa
import RxSwift

protocol HomeViewControllerProtocol: AnyObject {
    func resetBatteryViewConfigure()
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {
    private weak var coordinator: HomeCoordinatorProtocol?
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
    var viewModel: HomeViewModelProtocol?
    var batteryView = BatteryView()
    
    static func create(viewModel: HomeViewModelProtocol,
                       coordinator: HomeCoordinatorProtocol) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        viewController.viewModel?.homeViewController = viewController
        
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
            batteryView.layer.masksToBounds = true
            batteryView.layer.cornerRadius = xValueRatio(30)
            batteryView.calendarCollectionView.isScrollEnabled = false
            batteryView.animateShapeLayer(selectedCellEntity.circleDangValue,
                                 selectedCellEntity.circleAnimationDuration)
            batteryView.countAnimation(selectedCellEntity.circlePercentValue)
            batteryView.targetSugar.text = "목표: " + selectedCellEntity.selectedDangValue + "/"
            + selectedCellEntity.selectedMaxDangValue
        
    }
    
    private func configure() {
        homeScrollView.backgroundColor = .clear
        homeScrollView.showsVerticalScrollIndicator = true
        homeScrollView.contentSize = CGSize(width: UIScreen.main.bounds.maxX,
                                            height: overSizeYValueRatio(1200))
        homeScrollView.contentInsetAdjustmentBehavior = .automatic
        homeScrollView.bounces = false
        homeScrollView.contentInsetAdjustmentBehavior = .never
        
        homeStackView.axis = .vertical
        homeStackView.spacing = 10
        homeStackView.backgroundColor = .homeBackgroundColor
        homeStackView.distribution = .fill
        homeStackView.alignment = .center
    }
    
    private func layout() {
        [ customNavigationBar, homeScrollView ].forEach() { view.addSubview($0) }
        [ homeStackView ].forEach() { homeScrollView.addSubview($0) }
        [ batteryView, ateFoodTitleView, ateFoodView,
          graphTitleView, homeGraphView ].forEach() { viewsInStackView.append($0) }
        viewsInStackView.forEach() { homeStackView.addArrangedSubview($0) }
        
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.topAnchor.constraint(equalTo: batteryView.topAnchor).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        heightAnchor = customNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(110))
        heightAnchor?.isActive = true
        
        homeScrollView.translatesAutoresizingMaskIntoConstraints = false
        homeScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        homeScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        homeStackView.translatesAutoresizingMaskIntoConstraints = false
        homeStackView.topAnchor.constraint(equalTo: homeScrollView.topAnchor).isActive = true
        homeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        batteryView.translatesAutoresizingMaskIntoConstraints = false
        batteryView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
        batteryViewHeightAnchor = batteryView.heightAnchor.constraint(equalToConstant: yValueRatio(500))
        batteryViewHeightAnchor?.isActive = true
        batteryView.calendarViewTopAnchor?.constant = selectedDayYValue
        
        ateFoodTitleView.translatesAutoresizingMaskIntoConstraints = false
        ateFoodTitleView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
        ateFoodTitleView.heightAnchor.constraint(equalToConstant: yValueRatio(50)).isActive = true
        
        ateFoodView.translatesAutoresizingMaskIntoConstraints = false
        ateFoodView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
        ateFoodView.heightAnchor.constraint(equalToConstant: yValueRatio(100)).isActive = true
        
        graphTitleView.translatesAutoresizingMaskIntoConstraints = false
        graphTitleView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
        graphTitleView.heightAnchor.constraint(equalToConstant: yValueRatio(50)).isActive = true
        
        homeGraphView.translatesAutoresizingMaskIntoConstraints = false
        homeGraphView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX-yValueRatio(40)).isActive = true
        homeGraphView.heightAnchor.constraint(equalToConstant: yValueRatio(300)).isActive = true
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
        bindNavigationImageButton()
    }
    
    private func bindBatteryViewModel() {
        guard let viewModel = self.viewModel else { return }
        batteryView.bind(viewModel: viewModel)
    }
    
    private func bindAteFoodViewModel() {
        viewModel?.dangComprehensiveData
            .subscribe(onNext: { [weak self] in
                guard let tempDang = $0.tempDang,
                      let tempFoodName = $0.tempFoodName else { return }
                let ateFoodViewModel = AteFoodViewModel(item: AteFoodData(
                    dangArray: tempDang,
                    foodNameArray: tempFoodName)
                )
                self?.ateFoodView.bind(viewModel: ateFoodViewModel)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindHomeGraphViewModel() {
        viewModel?.dangComprehensiveData
            .subscribe(onNext: { [weak self] in
                guard let weekDang = $0.weekDang,
                      let monthDang = $0.monthDang,
                      let yearDang = $0.yearDang else { return }
                let homeGraphViewModel = GraphViewModel(
                    item: GraphViewEntity(weekDang: weekDang,
                                          monthDang: monthDang,
                                          yearDang: yearDang)
                )
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
    
    private func bindNavigationImageButton() {
        customNavigationBar.profileImageButton.rx.tap
            .bind { [weak self] in
                guard let viewController = self else { return }
                self?.coordinator?.navigationEvent(
                    event: .present,
                    type: .profile(viewController)
                )
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCalendarScaleAnimation() {
        customNavigationBar.yearMonthButton.rx.tap
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
        batteryView.animateShapeLayer(selectedCellEntity.circleDangValue,
                                      selectedCellEntity.circleAnimationDuration)
        batteryView.countAnimation(selectedCellEntity.circlePercentValue)
        batteryView.targetSugar.text = "목표: " + selectedCellEntity.selectedDangValue + "/" + selectedCellEntity.selectedMaxDangValue
        batteryView.animationLineLayer.strokeColor = selectedCellEntity.selectedCircleColor
        batteryView.percentLineBackgroundLayer.strokeColor = selectedCellEntity.selectedCircleBackgroundColor
        batteryView.percentLineLayer.strokeColor = selectedCellEntity.selectedAnimationLineColor
        batteryView.animatePulsatingLayer()
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
