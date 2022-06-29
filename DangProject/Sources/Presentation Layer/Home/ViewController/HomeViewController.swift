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
    
    private let disposeBag = DisposeBag()
    private let customNavigationBar = CustomNavigationBar()
    
    private let eatenFoodsTitleView = EatenFoodsTitleView()
    private let eatenFoodsView: EatenFoodsView
    private let batteryView: BatteryView
    private let calendarView: CalendarView
    
    private let graphTitleView = GraphTitleView()
    private var homeGraphView = HomeGraphView()
    
    private var homeScrollView = UIScrollView()
    private var homeStackView = UIStackView()
    private var viewsInStackView: [UIView] = []
    private lazy var homeScrollViewTopAnchor: NSLayoutConstraint = {
        homeScrollView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: yValueRatio(60))
    }()
    private lazy var calendarViewTopAnchor = NSLayoutConstraint()
    
    var viewModel: HomeViewModelProtocol
    
    init(viewModel: HomeViewModelProtocol,
         calendarView: CalendarView,
         eatenFoodsView: EatenFoodsView,
         batteryView: BatteryView) {
        self.calendarView = calendarView
        self.eatenFoodsView = eatenFoodsView
        self.batteryView = batteryView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendarView.returnCurrentCalendarView()
        viewModel.refreshHomeViewController(dateComponents: .currentDateTimeComponents())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .homeBackgroundColor
        configure()
        configureTodayCalendarColumn()
        layout()
    }
    
    private func configure() {
        let navigationTitle = viewModel.checkNavigationBarTitleText(dateComponents: .currentDateComponents())
        customNavigationBar.changeNavigationBarTitleLabel(text: navigationTitle)
        customNavigationBar.parentableViewController = self
        
        calendarView.parentableViewController = self
        
        homeScrollView.backgroundColor = .clear
        homeScrollView.showsVerticalScrollIndicator = true
        homeScrollView.contentSize = CGSize(width: UIScreen.main.bounds.maxX,
                                            height: overSizeYValueRatio(1200))
        homeScrollView.contentInsetAdjustmentBehavior = .automatic
        homeScrollView.bounces = false
        homeScrollView.contentInsetAdjustmentBehavior = .never
        homeScrollView.delegate = self
        
        homeStackView.axis = .vertical
        homeStackView.spacing = 10
        homeStackView.backgroundColor = .homeBackgroundColor
        homeStackView.distribution = .fill
        homeStackView.alignment = .center
    }
    
    private func configureTodayCalendarColumn() {
        let column = calendarView.todayCellColumn
        calendarViewTopAnchor = calendarView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: -yValueRatio(60)*CGFloat(column))
        viewModel.changeCellIndexColumn(cellIndexColumn: column)
    }
    
    private func layout() {
        [ customNavigationBar, calendarView, homeScrollView ].forEach() { view.addSubview($0) }
        [ homeStackView ].forEach() { homeScrollView.addSubview($0) }
        [ batteryView, eatenFoodsTitleView, eatenFoodsView,
          graphTitleView, homeGraphView ].forEach() { viewsInStackView.append($0) }
        viewsInStackView.forEach() { homeStackView.addArrangedSubview($0) }
        
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(110)).isActive = true
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarViewTopAnchor.isActive = true
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calendarView.heightAnchor.constraint(equalToConstant: yValueRatio(360)).isActive = true
        self.view.sendSubviewToBack(calendarView)
        
        homeScrollView.translatesAutoresizingMaskIntoConstraints = false
        homeScrollViewTopAnchor.isActive = true
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
extension HomeViewController: CalendarViewDelegate {
    func cellDidSelected(dateComponents: DateComponents, cellIndexColumn: Int) {
        viewModel.refreshHomeViewController(dateComponents: dateComponents)
        viewModel.changeCellIndexColumn(cellIndexColumn: cellIndexColumn)
        changeEatenFoodsTitleViewText(dateComponents: dateComponents)
    }
    
    func fetchEatenFoodsPerMonths(_ dateComponents: DateComponents) {
        changeNavigationBarTitleText(dateComponents: dateComponents)
        viewModel.fetchEatenFoodsInTotalMonths(dateComponents)
    }
    
    private func changeCalendarViewTopAnchor() {
        calendarViewTopAnchor = calendarView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: -yValueRatio(60)*CGFloat(viewModel.calendarViewColumn))
    }
    
    private func resetCalendarViewTopAnchor() {
        calendarViewTopAnchor = calendarView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor)
    }
    
    private func changeEatenFoodsTitleViewText(dateComponents: DateComponents) {
        let eatenFoodsTitleText = viewModel.checkEatenFoodsTitleText(dateComponents: dateComponents)
        eatenFoodsTitleView.changeEatenFoodsTitleLabel(text: eatenFoodsTitleText)
    }
    
    private func changeNavigationBarTitleText(dateComponents: DateComponents) {
        let navigationBarTitleText = viewModel.checkNavigationBarTitleText(dateComponents: dateComponents)
        customNavigationBar.changeNavigationBarTitleLabel(text: navigationBarTitleText)
    }
}

extension HomeViewController: NavigationBarDelegate {
    func changeViewControllerExpandation(state: ChevronButtonState) {
        self.homeScrollViewTopAnchor.isActive = false
        self.calendarViewTopAnchor.isActive = false
        switch state {
        case .expand:
            resetCalendarViewTopAnchor()
            expandAnimation()
        case .revert:
            changeCalendarViewTopAnchor()
            revertAnimation()
            calendarView.returnSelectedCalendarView()
        }
        self.calendarViewTopAnchor.isActive = true
        self.homeScrollViewTopAnchor.isActive = true
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        // 다시중앙으로만 오면됨
//        calendarView.makeContentOffsetCentered()
    }
    
    private func revertAnimation() {
        self.homeScrollViewTopAnchor = homeScrollView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: yValueRatio(60))
        self.homeScrollView.isScrollEnabled = true   
    }
    
    private func expandAnimation() {
        self.homeScrollViewTopAnchor = homeScrollView.topAnchor.constraint(equalTo: calendarView.bottomAnchor)
        self.homeScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.homeScrollView.isScrollEnabled = false
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        print(scrollView.contentOffset.y)
    //        let targetVerticalPointee = scrollView.contentOffset.y
    //        let navigationBarCalendarViewHeight = customNavigationBar.frame.height + yValueRatio(60)
    //        UIView.animate(withDuration: 0.5) { [weak self] in
    //            guard let strongSelf = self else { return }
    //
    //            self?.homeScrollViewTopAnchor.isActive = false
    //            if targetVerticalPointee > 0 {
    //                self?.homeScrollViewTopAnchor = scrollView.topAnchor.constraint(equalTo: strongSelf.view.topAnchor, constant: navigationBarCalendarViewHeight-targetVerticalPointee)
    //                self?.homeScrollViewTopAnchor.isActive = true
    //            }
    //        }
    //    }
    
}
