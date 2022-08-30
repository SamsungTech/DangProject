//
//  TermViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import UIKit
import RxSwift

class TermViewController: CustomViewController {
    var coordinator: TermCoordinator?
    private var viewModel: TermViewModel?
    private let disposeBag = DisposeBag()
    private lazy var navigationBar: CommonNavigationBar = {
        let navigationBar = CommonNavigationBar()
        navigationBar.accountTitleLabel.text = "이용약관"
        return navigationBar
    }()
    
    init(viewModel: TermViewModel) {
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
}

extension TermViewController {
    private func configureUI() {
        setUpView()
        setUpNavigationBar()
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
    
    private func bindUI() {
        bindNavigationBackButton()
    }
    
    private func bindNavigationBackButton() {
        navigationBar.backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.popTermViewController()
            }
            .disposed(by: disposeBag)
    }
}
