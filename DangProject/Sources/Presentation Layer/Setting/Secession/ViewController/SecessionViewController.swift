//
//  SecessionViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import UIKit
import RxSwift

class SecessionViewController: UIViewController {
    private var viewModel: SecessionViewModel?
    var coordinator: SecessionCoordinator?
    private let disposeBag = DisposeBag()
    private lazy var navigationBar: CommonNavigationBar = {
        let navigationBar = CommonNavigationBar()
        navigationBar.accountTitleLabel.text = "탈퇴"
        return navigationBar
    }()
    
    private var waningView = WarningView()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .homeBoxColor
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.setTitle("탈퇴하기", for: .normal)
        return button
    }()
    
    init(viewModel: SecessionViewModel) {
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

extension SecessionViewController {
    private func configureUI() {
        setUpView()
        setUpNavigationBar()
        setUpWaningView()
        setUpDeleteButton()
    }
    
    private func setUpView() {
        view.backgroundColor = .homeBackgroundColor
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
    
    private func setUpWaningView() {
        view.addSubview(waningView)
        waningView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            waningView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: yValueRatio(50)),
            waningView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            waningView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            waningView.heightAnchor.constraint(equalToConstant: yValueRatio(120))
        ])
    }
    
    private func setUpDeleteButton() {
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: waningView.bottomAnchor, constant: yValueRatio(30)),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func bindUI() {
        navigationBar.backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.popSecessionViewController()
            }
            .disposed(by: disposeBag)
    }
}
