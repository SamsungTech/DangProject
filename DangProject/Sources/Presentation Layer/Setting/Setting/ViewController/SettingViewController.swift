//
//  SettingViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import UIKit

import RxSwift

class SettingViewController: CustomViewController, CustomTabBarIsNeeded {
    
    var coordinator: SettingCoordinator?
    private let viewModel: SettingViewModelProtocol
    private let disposeBag = DisposeBag()
    private var settingNavigationBar = SettingNavigationBar()
    private lazy var settingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentSize = CGSize(width: calculateXMax(),
                                        height: overSizeYValueRatio(800))
        return scrollView
    }()
    
    private(set) lazy var accountView: SettingAccountView = {
        let button = SettingAccountView()
        button.backgroundColor = .homeBoxColor
        return button
    }()
    
    private var settingFirstStackView = SettingFirstStackView()
    private var settingSecondStackView = SettingSecondStackView()
    private var settingTermsOfServiceView = SettingTermsOfServiceView()
    private var settingSecessionView = SettingSecessionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        bindUI()
        view.bringSubviewToFront(settingNavigationBar)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserNameAndImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(self.coordinator)
    }
    
    init(viewModel: SettingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setupBackgroundView()
        setupNavigationBar()
        setupSettingScrollView()
        setupAccountView()
        setupSettingFirstStackView()
        setupSettingSecondStackView()
        setupSettingTermsOfServiceView()
        setupSettingSecessionView()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .homeBackgroundColor
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupNavigationBar() {
        view.addSubview(settingNavigationBar)
        settingNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingNavigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: -yValueRatio(5)),
            settingNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -xValueRatio(5)),
            settingNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: xValueRatio(5)),
            settingNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(95))
        ])
    }
    
    private func setupSettingScrollView() {
        view.addSubview(settingScrollView)
        settingScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingScrollView.topAnchor.constraint(equalTo: settingNavigationBar.bottomAnchor),
            settingScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupAccountView() {
        settingScrollView.addSubview(accountView)
        accountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountView.topAnchor.constraint(equalTo: settingScrollView.topAnchor),
            accountView.heightAnchor.constraint(equalToConstant: yValueRatio(100)),
            accountView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX)
        ])
    }
    
    private func setupSettingFirstStackView() {
        settingScrollView.addSubview(settingFirstStackView)
        settingFirstStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingFirstStackView.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: yValueRatio(10)),
            settingFirstStackView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            settingFirstStackView.heightAnchor.constraint(equalToConstant: xValueRatio(120))
        ])
    }
    
    private func setupSettingSecondStackView() {
        settingScrollView.addSubview(settingSecondStackView)
        settingSecondStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingSecondStackView.topAnchor.constraint(equalTo: settingFirstStackView.bottomAnchor, constant: yValueRatio(10)),
            settingSecondStackView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            settingSecondStackView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setupSettingTermsOfServiceView() {
        settingScrollView.addSubview(settingTermsOfServiceView)
        settingTermsOfServiceView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingTermsOfServiceView.topAnchor.constraint(equalTo: settingSecondStackView.bottomAnchor, constant: yValueRatio(10)),
            settingTermsOfServiceView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            settingTermsOfServiceView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setupSettingSecessionView() {
        settingScrollView.addSubview(settingSecessionView)
        settingSecessionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingSecessionView.topAnchor.constraint(equalTo: settingTermsOfServiceView.bottomAnchor, constant: yValueRatio(10)),
            settingSecessionView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            settingSecessionView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }

    private func bind() {
        bindScrollStateValue()
        bindAccountViewData()
    }
    
    private func bindAccountViewData() {
        viewModel.profileDataRelay
            .subscribe(onNext: { [weak self] accountViewData in
                self?.accountView.configureUserImage(accountViewData.0)
                self?.accountView.configureUserName(accountViewData.1)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindScrollStateValue() {
        viewModel.scrollStateRelay
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .top:
                    self.settingNavigationBar.setupSettingScrollViewTop()
                case .scrolling:
                    self.settingNavigationBar.setupSettingScrollViewScrolling()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        Observable.merge(
            accountView.rx.tap.map { SettingRouterPath.account },
            settingFirstStackView.myTargetView.rx.tap.map { SettingRouterPath.myTarget },
            settingFirstStackView.alarmView.rx.tap.map { SettingRouterPath.alarm },
            settingTermsOfServiceView.rx.tap.map { SettingRouterPath.termsOfService },
            settingSecessionView.rx.tap.map { SettingRouterPath.secession }
        )
            .bind { [weak self] in
                switch $0 {
                case .account:
                    self?.coordinator?.decideViewController(.account)
                case .myTarget:
                    self?.coordinator?.decideViewController(.myTarget)
                case .alarm:
                    self?.coordinator?.decideViewController(.alarm)
                case .termsOfService:
                    self?.coordinator?.decideViewController(.termsOfService)
                case .secession:
                    self?.coordinator?.decideViewController(.secession)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yValue = scrollView.contentOffset.y
        viewModel.checkScrollValue(yValue)
    }
}
