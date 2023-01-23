//
//  ViewController.swift
//  DangProject
//
//  Created by 김동우 on 2021/12/20.
//

import UIKit

import RxCocoa
import RxSwift

class HomeViewController: CustomViewController, CustomTabBarIsNeeded {
    weak var coordinator: HomeCoordinator?
    private let disposeBag = DisposeBag()
    private let customNavigationBar = CustomNavigationBar()
    
    private let viewModel: HomeViewModelProtocol
    private let eatenFoodsView: EatenFoodsView
    private let batteryView: BatteryView
    private let calendarView: CalendarView
    private var graphView: GraphView
    
    private let eatenFoodsTitleView = EatenFoodsTitleView()
    private let graphTitleView = GraphTitleView()
    
    private var homeScrollView = UIScrollView()
    private var homeStackView = UIStackView()
    private lazy var homeStackViewTopAnchor: NSLayoutConstraint = {
        homeStackView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: yValueRatio(60))
    }()
    private lazy var calendarViewTopAnchor = NSLayoutConstraint()
    private lazy var loadingView = LoadingView(frame: .zero)

    init(viewModel: HomeViewModelProtocol,
         calendarView: CalendarView,
         eatenFoodsView: EatenFoodsView,
         batteryView: BatteryView,
         graphView: GraphView) {
        self.calendarView = calendarView
        self.eatenFoodsView = eatenFoodsView
        self.batteryView = batteryView
        self.graphView = graphView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        calendarView.dataCheckDelegate = self
        eatenFoodsView.dataCheckDelegate = self
        batteryView.dataCheckDelegate = self
        graphView.dataCheckDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchProfileData()
        calendarView.showCurrentCalendarView()
        viewModel.fetchCurrentMonthData(dateComponents: .currentDateTimeComponents())
        changeNavigationBarTitleText(dateComponents: .currentDateTimeComponents())
        viewModel.loading.accept(.startLoading)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .homeBackgroundColor
        configure()
        configureTodayCalendarColumn()
        layout()
        bindProfileImageData()
        bindLoading()
        bindAlertState()
    }
    
    private func configure() {
        let navigationTitle = viewModel.checkNavigationBarTitleText(dateComponents: .currentDateComponents())
        customNavigationBar.changeNavigationBarTitleLabel(text: navigationTitle)
        customNavigationBar.parentableViewController = self
        calendarView.parentableViewController = self
        
        homeScrollView.backgroundColor = .clear
        homeScrollView.contentInsetAdjustmentBehavior = .automatic
        homeScrollView.bounces = false
        homeScrollView.contentInsetAdjustmentBehavior = .never
        homeScrollView.showsVerticalScrollIndicator = false
        
        homeStackView.axis = .vertical
        homeStackView.spacing = yValueRatio(10)
        homeStackView.backgroundColor = .homeBackgroundColor
        homeStackView.distribution = .equalSpacing
        homeStackView.alignment = .center
    }
    
    private func configureTodayCalendarColumn() {
        let column = calendarView.todayCellColumn
        calendarViewTopAnchor = calendarView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: -yValueRatio(60)*CGFloat(column))
        viewModel.changeCellIndexColumn(cellIndexColumn: column)
    }
    
    private func layout() {
        [ homeScrollView, loadingView ].forEach() { view.addSubview($0) }
        [ customNavigationBar, calendarView, homeStackView ].forEach() { homeScrollView.addSubview($0) }
        createHomeStackView()

        
        homeScrollView.translatesAutoresizingMaskIntoConstraints = false
        homeScrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        homeScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        homeScrollView.contentLayoutGuide.heightAnchor.constraint(equalToConstant: yValueRatio(1200)).isActive = true
        
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.topAnchor.constraint(equalTo: homeScrollView.topAnchor).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(110)).isActive = true
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarViewTopAnchor.isActive = true
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: homeScrollView.trailingAnchor).isActive = true
        calendarView.heightAnchor.constraint(equalToConstant: yValueRatio(360)).isActive = true
        homeScrollView.sendSubviewToBack(calendarView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.center = view.center
    }
    
    private func createHomeStackView() {
        var viewsInStackView: [UIView] = []
        
        homeStackView.translatesAutoresizingMaskIntoConstraints = false
        homeStackViewTopAnchor.isActive = true
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

        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX-xValueRatio(40)).isActive = true
        graphView.heightAnchor.constraint(equalToConstant: yValueRatio(300)).isActive = true
        
        [ batteryView, eatenFoodsTitleView, eatenFoodsView,
          graphTitleView, graphView ].forEach() { viewsInStackView.append($0) }
        viewsInStackView.forEach() { homeStackView.addArrangedSubview($0) }
    }
    
    private func bindProfileImageData() {
        viewModel.profileDataRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] profileData in
                guard let strongSelf = self else { return }
                self?.customNavigationBar.profileImageButton.setupProfileImageViewImage(profileData.profileImage)
                strongSelf.checkIsFirstVersionCheck()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLoading() {
        viewModel.loading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .startLoading:
                    self?.loadingView.showLoading()
                case .finishLoading:
                    self?.loadingView.hideLoading()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAlertState() {
        viewModel.alertStateRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                if state {
                    guard let alert = self?.createAlert() else { return }
                    self?.present(alert, animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func checkIsFirstVersionCheck() {
        if viewModel.getIsFirstVersionCheck() {
            self.coordinator?.presentUpdateAlertView()
            viewModel.setupIsFirstVersionCheck()
        }
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: "오류",
                                      message: "firebaseServer 연결 오류",
                                      preferredStyle: UIAlertController.Style.alert)
        let actionButton = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: false)
        }
        alert.addAction(actionButton)
        return alert
    }
}
extension HomeViewController: CalendarViewDelegate {
    func cellDidSelected(dateComponents: DateComponents,
                         cellIndexColumn: Int) {
        viewModel.fetchProfileData()
        viewModel.fetchSelectedEatenFoods(dateComponents)
        viewModel.changeCellIndexColumn(cellIndexColumn: cellIndexColumn)
        changeEatenFoodsTitleViewText(dateComponents: dateComponents)
        viewModel.fetchGraphData(from: dateComponents)
    }
    
    func changeCalendarView(_ dateComponents: DateComponents,
                            fetchIsNeeded: Bool) {
        changeNavigationBarTitleText(dateComponents: dateComponents)
        if fetchIsNeeded {
            viewModel.fetchEatenFoodsInTotalMonths(dateComponents)
        } else {
            viewModel.fetchOnlyCalendar(dateComponents)
        }
    }
    
    private func changeCalendarViewTopAnchor() {
        calendarViewTopAnchor = calendarView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: -yValueRatio(60)*CGFloat(viewModel.calendarViewColumn))
    }
    
    private func resetCalendarViewTopAnchor() {
        calendarViewTopAnchor = calendarView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor)
    }
    
    private func changeEatenFoodsTitleViewText(dateComponents: DateComponents) {
        let eatenFoodsTitleText = viewModel.getEatenFoodsTitleText(dateComponents: dateComponents)
        eatenFoodsTitleView.changeEatenFoodsTitleLabel(text: eatenFoodsTitleText)
    }
    
    private func changeNavigationBarTitleText(dateComponents: DateComponents) {
        let navigationBarTitleText = viewModel.checkNavigationBarTitleText(dateComponents: dateComponents)
        customNavigationBar.changeNavigationBarTitleLabel(text: navigationBarTitleText)
    }
}

extension HomeViewController: NavigationBarDelegate {
    func profileImageButtonDidTap() {
        coordinator?.pushProfileEditViewController()
    }
    
    func changeViewControllerExpandation(state: ChevronButtonState) {
        self.calendarViewTopAnchor.isActive = false
        self.homeStackViewTopAnchor.isActive = false
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
        self.homeStackViewTopAnchor.isActive = true
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    private func revertAnimation() {
        self.homeStackViewTopAnchor = homeStackView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: yValueRatio(60))
        self.homeScrollView.isScrollEnabled = true
    }
    
    private func expandAnimation() {
        self.homeStackViewTopAnchor = homeStackView.topAnchor.constraint(equalTo: calendarView.bottomAnchor)
        self.homeScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.homeScrollView.isScrollEnabled = false
    }
}

extension HomeViewController: CheckDataProtocol {
    func checkData() {
        viewModel.plusViewsDataCount()
    }
}

