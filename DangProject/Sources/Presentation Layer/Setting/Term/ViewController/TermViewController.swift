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
    private var viewModel: TermViewModel
    private let disposeBag = DisposeBag()
    private lazy var navigationBar: CommonNavigationBar = {
        let navigationBar = CommonNavigationBar()
        navigationBar.accountTitleLabel.font = UIFont.systemFont(ofSize: yValueRatio(20), weight: .bold)
        navigationBar.accountTitleLabel.text = "이용약관"
        return navigationBar
    }()
    
    private lazy var termsAndConditionsTextField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: xValueRatio(18), weight: .bold)
        textView.textColor = UIColor.customLabelColorBlack2
        textView.textAlignment = .left
        textView.text = viewModel.personalInformation
        textView.isEditable = false
        return textView
    }()
    
    init(viewModel: TermViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        setupView()
        setupNavigationBar()
        setupTermsAndConditionsLabel()
    }
    
    private func setupView() {
        view.backgroundColor = .homeBoxColor
    }
    
    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(90))
        ])
    }
    
    private func setupTermsAndConditionsLabel() {
        view.addSubview(termsAndConditionsTextField)
        termsAndConditionsTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            termsAndConditionsTextField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            termsAndConditionsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            termsAndConditionsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            termsAndConditionsTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
