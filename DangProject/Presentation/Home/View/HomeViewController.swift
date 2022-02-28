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
    private var isExpandBatteryView = false
    private var scrollDiection: ScrollDiection?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let centerPoint = CGPoint(x: UIScreen.main.bounds.maxX, y: .zero)
        batteryView.calendarScrollView.setContentOffset(centerPoint, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(coordinator)
    }
    
    private func configure() {
        homeScrollView.do {
            $0.backgroundColor = .systemGreen
            $0.showsVerticalScrollIndicator = true
            $0.contentSize = CGSize(width: UIScreen.main.bounds.maxX, height: 1200)
            $0.contentInsetAdjustmentBehavior = .automatic
            $0.bounces = false
        }
        homeStackView.do {
            $0.axis = .vertical
            $0.spacing = 50
            $0.backgroundColor = .blue
            $0.distribution = .fill
            $0.alignment = .center
        }
        batteryView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 30
            $0.calendarScrollView.delegate = self
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
            $0.topAnchor.constraint(equalTo: homeScrollView.topAnchor, constant: -47).isActive = true
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
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        homeGraphView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX-40).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }
        customNavigationBar.yearMouthButton.rx.tap
            .bind {
                self.batteryAnimation()
            }
            .disposed(by: disposeBag)
        bind()
    }
    
    private func bind() {
        if let viewModel = viewModel?.tempData.value {
            let ateFoodViewModel = AteFoodItemViewModel(item: viewModel)
            ateFoodView.bind(viewModel: ateFoodViewModel)
        }
        
        if let viewModel = viewModel?.weekData.value {
            let homeGraphViewModel = GraphItemViewModel(item: viewModel)
            homeGraphView.bind(viewModel: homeGraphViewModel)
        }
        viewModel?.batteryData
            .subscribe({ data in
                if let homeViewModel = self.viewModel?.batteryData.value {
                    let calendarViewModel = BatteryCellViewModel(batteryData: homeViewModel)
                    calendarViewModel.publishBatteryData.accept(data.element!)
                    self.batteryView.bind(viewModel: calendarViewModel)
                }
                self.customNavigationBar.dateLabel.text = data.element!.calendar?[1].yearMouth
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
        batteryView.scrollViewTopAnchor?.constant = 110
        batteryView.cirlceProgressBarTopAnchor?.constant = 400
        heightAnchor1?.constant = UIScreen.main.bounds.maxY
        homeScrollView.contentSize = CGSize(width: UIScreen.main.bounds.maxX, height: 1544)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        isExpandBatteryView = true
    }
    
    private func revertAnimation() {
        batteryView.scrollViewTopAnchor?.constant = -70
        batteryView.cirlceProgressBarTopAnchor?.constant = 170
        heightAnchor1?.constant = 500
        homeScrollView.contentSize = CGSize(width: UIScreen.main.bounds.maxX, height: 1200)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        isExpandBatteryView = false
    }
    
    func scrollLeftDiection() {
        viewModel?.retrivePreviousMouthData()
        
    }
    
    func scrollRightDirection() {
        viewModel?.retriveNextMouthData()
    }
}

extension HomeViewController: UIScrollViewDelegate {
    private func updateCalendarPoint() {
        let centerPoint = CGPoint(x: batteryView.frame.width, y: .zero)
        batteryView.calendarScrollView.setContentOffset(centerPoint, animated: false)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch targetContentOffset.pointee.x {
        case 0:
            scrollDiection = .left
            print("왼쪽")
        case batteryView.frame.width * CGFloat(1):
            break
        case batteryView.frame.width * CGFloat(2):
            scrollDiection = .right
            print("오른쪽")
        default:
            break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollDiection {
        case .left:
            print("왼쪽")
            updateCalendarPoint()
            scrollLeftDiection()
        case .none?:
            break
        case .right:
            print("오른쪽")
            updateCalendarPoint()
            scrollRightDirection()
        default:
            break
        }
    }
}
