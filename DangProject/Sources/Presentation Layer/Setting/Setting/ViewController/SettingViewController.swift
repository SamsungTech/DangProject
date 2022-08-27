//
//  SettingViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import UIKit
import RxSwift

class SettingViewController: UIViewController {
    private var viewModel: SettingViewModelProtocol?
    var coordinator: SettingCoordinator?
    private let disposeBag = DisposeBag()
    private var settingNavigationBar = SettingNavigationBar()
    private lazy var settingLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = UIFont.systemFont(ofSize: xValueRatio(25), weight: .heavy)
        label.textAlignment = .left
        return label
    }()
    
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
        button.profileAccountLabel.text = "김동우"
        button.profileAccountLabel.textColor = .white
        button.frame = CGRect(x: .zero,
                              y: .zero,
                              width: calculateXMax(),
                              height: yValueRatio(80))
        button.backgroundColor = .homeBoxColor
        return button
    }()
    
    private lazy var secessionAlertController: UIAlertController = {
        let alert = UIAlertController(title: "탈퇴하기", message: "진짜 탈퇴할거야?", preferredStyle: .alert)
        
        return alert
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.childDidFinish(self.coordinator)
    }
    
    init(viewModel: SettingViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setUpSettingView()
        setUpNavigationBar()
        setUpSettingScrollView()
        setUpAccountView()
        setUpSettingFirstStackView()
        setUpSettingSecondStackView()
        setUpSettingTermsOfServiceView()
        setUpSettingSecessionView()
        setUpSecessionAlert()
    }
    
    private func setUpSettingView() {
        view.bringSubviewToFront(settingNavigationBar)
        view.backgroundColor = .homeBackgroundColor
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpNavigationBar() {
        view.addSubview(settingNavigationBar)
        settingNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingNavigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: -yValueRatio(5)),
            settingNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -xValueRatio(5)),
            settingNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: xValueRatio(5)),
            settingNavigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(95))
        ])
    }
    
    private func setUpSettingScrollView() {
        view.addSubview(settingScrollView)
        settingScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingScrollView.topAnchor.constraint(equalTo: settingNavigationBar.bottomAnchor),
            settingScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpAccountView() {
        settingScrollView.addSubview(accountView)
        accountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountView.topAnchor.constraint(equalTo: settingScrollView.topAnchor),
            accountView.heightAnchor.constraint(equalToConstant: yValueRatio(100)),
            accountView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX)
        ])
    }
    
    private func setUpSettingFirstStackView() {
        settingScrollView.addSubview(settingFirstStackView)
        settingFirstStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingFirstStackView.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: yValueRatio(10)),
            settingFirstStackView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            settingFirstStackView.heightAnchor.constraint(equalToConstant: xValueRatio(180))
        ])
    }
    
    private func setUpSettingSecondStackView() {
        settingScrollView.addSubview(settingSecondStackView)
        settingSecondStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingSecondStackView.topAnchor.constraint(equalTo: settingFirstStackView.bottomAnchor, constant: yValueRatio(10)),
            settingSecondStackView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            settingSecondStackView.heightAnchor.constraint(equalToConstant: yValueRatio(120))
        ])
    }
    
    private func setUpSettingTermsOfServiceView() {
        settingScrollView.addSubview(settingTermsOfServiceView)
        settingTermsOfServiceView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingTermsOfServiceView.topAnchor.constraint(equalTo: settingSecondStackView.bottomAnchor, constant: yValueRatio(10)),
            settingTermsOfServiceView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            settingTermsOfServiceView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setUpSettingSecessionView() {
        settingScrollView.addSubview(settingSecessionView)
        settingSecessionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingSecessionView.topAnchor.constraint(equalTo: settingTermsOfServiceView.bottomAnchor, constant: yValueRatio(10)),
            settingSecessionView.widthAnchor.constraint(equalToConstant: calculateXMax()),
            settingSecessionView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setUpSecessionAlert() {
        secessionAlertController.addAction(UIAlertAction(title: "취소",
                                                         style: .cancel,
                                                         handler: nil))
        secessionAlertController.addAction(UIAlertAction(title: "탈퇴하기",
                                                         style: .destructive,
                                                         handler: nil))
    }
    
    private func bind() {
        bindScrollStateValue()
    }
    
    private func bindScrollStateValue() {
        viewModel?.scrollStateRelay
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .top:
                    self.settingNavigationBar.setUpSettingScrollViewTop()
                case .scrolling:
                    self.settingNavigationBar.setUpSettingScrollViewScrolling()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        Observable.merge(
            accountView.rx.tap.map { SettingRouterPath.account },
            settingFirstStackView.myTargetView.rx.tap.map { SettingRouterPath.myTarget },
            settingFirstStackView.themeView.rx.tap.map { SettingRouterPath.theme },
            settingFirstStackView.alarmView.rx.tap.map { SettingRouterPath.alarm },
            settingSecondStackView.introductionView.rx.tap.map { SettingRouterPath.appIntroduce },
            settingTermsOfServiceView.rx.tap.map { SettingRouterPath.termsOfService },
            settingSecessionView.rx.tap.map { SettingRouterPath.secession }
        )
            .bind { [weak self] in
                switch $0 {
                case .account:
                    self?.coordinator?.decideViewController(.account)
                case .myTarget:
                    self?.coordinator?.decideViewController(.myTarget)
                case .theme:
                    self?.coordinator?.decideViewController(.theme)
                case .alarm:
                    self?.coordinator?.decideViewController(.alarm)
                case .appIntroduce:
                    self?.coordinator?.decideViewController(.appIntroduce)
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
        viewModel?.checkScrollValue(yValue)
    }
}
