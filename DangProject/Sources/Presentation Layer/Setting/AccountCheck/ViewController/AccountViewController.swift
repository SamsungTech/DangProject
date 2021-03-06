//
//  AccountViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/13.
//

import UIKit

import RxSwift

class AccountViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: AccountViewModel?
    var coordinator: AccountCoordinator?
    private lazy var navigationBar: CommonNavigationBar = {
        let navigationBar = CommonNavigationBar()
        navigationBar.accountTitleLabel.text = "내 계정"
        return navigationBar
    }()
    private lazy var accountScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: calculateXMax(), height: yValueRatio(800))
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    private var stackView: AccountStackView = {
        let stackView = AccountStackView()
        return stackView
    }()
    
    private(set) lazy var logoutView: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.backgroundColor = .homeBoxColor
        button.setTitleColor(UIColor.circleColorRed, for: .normal)
        return button
    }()
    
    init(viewModel: AccountViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func configureUI() {
        setUpView()
        setUpAccountNavigationBar()
        setUpAccountScrollView()
        setUpStackView()
        setUpLogoutView()
    }
    
    private func setUpView() {
        view.backgroundColor = .homeBackgroundColor
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpAccountNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(90))
        ])
    }
    
    private func setUpAccountScrollView() {
        view.addSubview(accountScrollView)
        accountScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountScrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            accountScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accountScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accountScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpStackView() {
        accountScrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: accountScrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: yValueRatio(120))
        ])
    }
    
    private func setUpLogoutView() {
        accountScrollView.addSubview(logoutView)
        logoutView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: yValueRatio(20)),
            logoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoutView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func bindUI() {
        navigationBar.backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.popAccountViewController()
            }
            .disposed(by: disposeBag)
        
        stackView.profileEditView.rx.tap
            .bind { [weak self] in
                self?.coordinator?.pushProfileEditViewController()
            }
            .disposed(by: disposeBag)
    }
}
