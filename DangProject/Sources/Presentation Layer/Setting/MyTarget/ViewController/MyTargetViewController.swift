//
//  MyTargetViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import UIKit
import RxSwift

class MyTargetViewController: CustomViewController {
    private var viewModel: MyTargetViewModel
    var coordinator: MyTargetCoordinator?
    private let disposeBag = DisposeBag()
    private lazy var targetView: MyTargetView = {
        let targetView = MyTargetView()
        targetView.targetNumberTextField.delegate = self
        return targetView
    }()
    private lazy var navigationBar: CommonNavigationBar = {
        let navigationBar = CommonNavigationBar()
        navigationBar.accountTitleLabel.text = "나의 목표 설정"
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchSugarLevel()
    }
    
    init(viewModel: MyTargetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.childDidFinish(self.coordinator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyTargetViewController {
    private func configureUI() {
        setUpView()
        setUpNavigationBar()
        setUpMyTargetView()
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
    
    private func setUpMyTargetView() {
        view.addSubview(targetView)
        targetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            targetView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: yValueRatio(50)),
            targetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            targetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            targetView.heightAnchor.constraint(equalToConstant: yValueRatio(300))
        ])
    }
    
    private func bind() {
        bindUI()
    }
    
    private func bindUI() {
        navigationBar.backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.popMyTargetViewController()
            }
            .disposed(by: disposeBag)
        
        targetView.toolBar.rx.tap
            .bind { [weak self] in
                let sugarLevel = Double(self?.targetView.targetNumberTextField.text ?? "")
                self?.targetView.animateLabel()
                self?.viewModel.saveTargetSugarLevel(sugarLevel ?? 0.0)
                self?.targetView.targetNumberTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        viewModel.profileDataRelay
            .subscribe(onNext: { [weak self] profileData in
                self?.targetView.bindTargetSugar(Double(profileData.sugarLevel))
            })
            .disposed(by: disposeBag)
    }
}

extension MyTargetViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let replace = Range(range, in: textFieldText) else { return false }
        let substring = textFieldText[replace]
        let count = textFieldText.count - substring.count + string.count
        
        return count <= 4
    }
}
