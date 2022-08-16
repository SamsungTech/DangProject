//
//  ThemeViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import UIKit
import RxSwift

class ThemeViewController: CustomViewController {
    private var viewModel: ThemeViewModel?
    var coordinator: ThemeCoordinator?
    private let disposeBag = DisposeBag()
    private var themeStackView = ThemeStackView()
    private lazy var navigationBar: CommonNavigationBar = {
        let navigationBar = CommonNavigationBar()
        navigationBar.accountTitleLabel.text = "화면모드 설정"
        return navigationBar
    }()
    
    init(viewModel: ThemeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

extension ThemeViewController {
    private func configureUI() {
        setUpView()
        setUpNavigationBar()
        setUpStackView()
    }
    
    private func setUpView() {
        view.backgroundColor = .homeBoxColor
    }
    
    private func setUpNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(90))
        ])
    }
    
    private func setUpStackView() {
        view.addSubview(themeStackView)
        themeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            themeStackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            themeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            themeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            themeStackView.heightAnchor.constraint(equalToConstant: yValueRatio(180))
        ])
    }
    
    private func bind() {
        bindModeRelay()
        bindUI()
    }
    
    private func bindModeRelay() {
        viewModel?.displayModeRelay
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .rightMode:
                    self?.themeStackView.setUpRightModeImageView()
                case .darkMode:
                    self?.themeStackView.setUpDarkModeImageView()
                case .systemMode:
                    self?.themeStackView.setUpSystemModeImageView()
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        navigationBar.backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.popThemeViewController()
            }
            .disposed(by: disposeBag)
        
        Observable.merge(
            themeStackView.rightMode.rx.tap.map { Mode.rightMode },
            themeStackView.darkMode.rx.tap.map { Mode.darkMode },
            themeStackView.systemMode.rx.tap.map { Mode.systemMode }
        )
            .bind(to: viewModel!.displayModeRelay)
            .disposed(by: disposeBag)
    }
}
