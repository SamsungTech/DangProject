//
//  ViewController.swift
//  DangProject
//
//  Created by 김동우 on 2021/12/20.
//

import UIKit

import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    weak var coordinator: HomeCoordinator?

    private var disposeBag = DisposeBag()
    private var customNavigationBar = CustomNavigationBar()
    
    private let eatenFoodsTitleView = EatenFoodsTitleView()
    private var eatenFoodsView: EatenFoodsView
    private var batteryView: BatteryView
    
    private let graphTitleView = GraphTitleView()
    private var homeGraphView = HomeGraphView()
    
    private var batteryViewHeightAnchor: NSLayoutConstraint?
    private var firstContentY: CGFloat = 0
    private var homeScrollView = UIScrollView()
    private var homeStackView = UIStackView()
    private var viewsInStackView: [UIView] = []
    private var isExpandBatteryView = false
    private var currentCGPoint: CGPoint = .zero
    private var selectedDayYValue: CGFloat = 0
    private var selectedCellEntity: SelectedCellEntity = .empty
    var viewModel: HomeViewModelProtocol
    
    
    init(viewModel: HomeViewModelProtocol,
         eatenFoodsView: EatenFoodsView,
         batteryView: BatteryView) {
        self.eatenFoodsView = eatenFoodsView
        self.batteryView = batteryView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 여기서 불러오면될것같음
        // 현재 + 전 후 달 eatenFoods
        
        viewModel.getEatenFoodsPerDay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .homeBackgroundColor
        viewModel.viewDidLoad()
        bindCurrentLineNumber()
        configure()
        layout()
        subscribe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        [ batteryView, eatenFoodsTitleView, eatenFoodsView,
          graphTitleView, homeGraphView ].forEach() { viewsInStackView.append($0) }
        viewsInStackView.forEach() { homeStackView.addArrangedSubview($0) }
        
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(110)).isActive = true
        
        homeScrollView.translatesAutoresizingMaskIntoConstraints = false
        homeScrollView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor).isActive = true
        homeScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        homeScrollView.contentLayoutGuide.heightAnchor.constraint(equalToConstant: yValueRatio(1200)).isActive = true
        
        homeStackView.translatesAutoresizingMaskIntoConstraints = false
        homeStackView.topAnchor.constraint(equalTo: homeScrollView.topAnchor).isActive = true
        homeStackView.leadingAnchor.constraint(equalTo: homeScrollView.leadingAnchor).isActive = true
        homeStackView.trailingAnchor.constraint(equalTo: homeScrollView.trailingAnchor).isActive = true
        homeStackView.heightAnchor.constraint(equalToConstant: yValueRatio(900)).isActive = true
        
        batteryView.translatesAutoresizingMaskIntoConstraints = false
        batteryView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
        batteryView.heightAnchor.constraint(equalToConstant: yValueRatio(300)).isActive = true
        
        eatenFoodsTitleView.translatesAutoresizingMaskIntoConstraints = false
        eatenFoodsTitleView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
        eatenFoodsTitleView.heightAnchor.constraint(equalToConstant: yValueRatio(50)).isActive = true
        
        eatenFoodsView.translatesAutoresizingMaskIntoConstraints = false
        eatenFoodsView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
        eatenFoodsView.heightAnchor.constraint(equalToConstant: yValueRatio(130)).isActive = true
        
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
        bindHomeGraphViewModel()
        bindCurrentDayPointData()
        bindCalendarScaleAnimation()
        bindSelectedCellViewData()
        bindNavigationImageButton()
    }
    
    private func bindHomeGraphViewModel() {
        viewModel.dangComprehensiveData
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
        viewModel.currentXPoint
            .subscribe(onNext: { [weak self] _ in
//                if let text = self?.viewModel.batteryViewCalendarData.value[$0].yearMonth {
//                    self?.customNavigationBar.dateLabel.text = text
//                }
            })
            .disposed(by: disposeBag)
        
        viewModel.currentDateCGPoint
            .subscribe(onNext: { [weak self] in
                self?.currentCGPoint = $0
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigationImageButton() {
        customNavigationBar.profileImageButton.rx.tap
            .bind { [weak self] in
                guard let viewController = self else { return }
                self?.coordinator?.presentProfile(viewController)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCalendarScaleAnimation() {
        customNavigationBar.yearMonthButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.calculateCalendarScaleState()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSelectedCellViewData() {
        viewModel.selectedCellViewData
            .subscribe(onNext: { [weak self] in
                self?.selectedCellEntity = $0
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCurrentLineNumber() {
        viewModel.currentLineYValue
            .subscribe(onNext: { [weak self] in
                self?.selectedDayYValue = $0
            })
            .disposed(by: disposeBag)
    }
}

//extension HomeViewController {
//    func resetBatteryViewConfigure() {
//        batteryView.animateShapeLayer(selectedCellEntity.circleDangValue,
//                                      selectedCellEntity.circleAnimationDuration)
//        batteryView.countAnimation(selectedCellEntity.circlePercentValue)
//        
//        
//        batteryView.targetSugar.text = "목표: " + selectedCellEntity.selectedDangValue + "/" + selectedCellEntity.selectedMaxDangValue
//        
//        
//        batteryView.animationLineLayer.strokeColor = selectedCellEntity.selectedCircleColor
//        batteryView.percentLineBackgroundLayer.strokeColor = selectedCellEntity.selectedCircleBackgroundColor
//        batteryView.percentLineLayer.strokeColor = selectedCellEntity.selectedAnimationLineColor
//        batteryView.animatePulsatingLayer()
//    }
//    
//    private func expandAnimation() {
//        batteryView.calendarCollectionView.isScrollEnabled = true
//        batteryView.calendarViewTopAnchor?.constant = yValueRatio(110)
//        batteryView.circleProgressBarTopAnchor?.constant = yValueRatio(470)
//        batteryViewHeightAnchor?.constant = UIScreen.main.bounds.maxY
//        homeScrollView.contentSize = CGSize(width: UIScreen.main.bounds.maxX,
//                                            height: overSizeYValueRatio(1544))
//        UIView.animate(withDuration: 0.5, animations: { [weak self] in
//            self?.view.layoutIfNeeded()
//        })
//        homeScrollView.isScrollEnabled = false
//        isExpandBatteryView = true
//    }
//    
//    private func revertAnimation() {
//        viewModel.calculateSelectedDayXPoint()
//        batteryView.calendarViewTopAnchor?.constant = selectedDayYValue
//        batteryView.circleProgressBarTopAnchor?.constant = yValueRatio(170)
//        batteryViewHeightAnchor?.constant = yValueRatio(500)
//        homeScrollView.contentSize = CGSize(width: UIScreen.main.bounds.maxX,
//                                            height: overSizeYValueRatio(1200))
//        UIView.animate(withDuration: 0.3, animations: { [weak self] in
//            self?.view.layoutIfNeeded()
//        }, completion: { [weak self] _ in
//            guard let currentCGPoint = self?.currentCGPoint else { return }
//            self?.batteryView.calendarCollectionView.setContentOffset(currentCGPoint, animated: true)
//        })
//        homeScrollView.isScrollEnabled = true
//        isExpandBatteryView = false
//        batteryView.calendarCollectionView.isScrollEnabled = false
//    }
//}
