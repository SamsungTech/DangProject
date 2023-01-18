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
    private lazy var timer = Timer()
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
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    init(viewModel: MyTargetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchProfileData()
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
        setupLoadingView()
    }
    
    private func setUpView() {
        targetView.delegate = self
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
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bind() {
        bindUI()
        bindTargetSugar()
    }
    
    private func bindUI() {
        navigationBar.backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.popMyTargetViewController()
            }
            .disposed(by: disposeBag)
        
        targetView.toolBar.rx.tap
            .bind { [weak self] in
                guard let strongSelf = self,
                      let targetSugar = Double(self?.targetView.targetNumberTextField.text ?? "") else { return }
                self?.loadingView.isHidden = false
                self?.targetView.animateLabel()
                strongSelf.passTargetSugarData(targetSugar: targetSugar)
                self?.targetView.targetNumberTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        viewModel.isTargetViewTextFieldRelay
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.targetView.setupTextFieldDoneButtonColorToGreen()
                } else {
                    self?.targetView.setupTextFieldDoneButtonColorToGray()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTargetSugar() {
        viewModel.targetSugarRelay
            .subscribe(onNext: { [weak self] targetSugar in
                self?.targetView.setUpTargetSugarNumber(targetSugar)
            })
            .disposed(by: disposeBag)
    }
    
    private func passTargetSugarData(targetSugar: Double) {
        viewModel.passTargetSugarForUpdate(targetSugar) { [weak self] data in
            if data == true {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self?.loadingView.isHidden = true
                    self?.coordinator?.popMyTargetViewController()
                }
            }
        }
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
        
        viewModel.checkCountZero(count)
        
        return count <= 4
    }
}

extension MyTargetViewController: TargetViewTextFieldFrontViewDelegate {
    func frontViewDidTap(_ textField: UITextField) {
        if textField.isEditing {
            self.targetView.targetNumberTextField.endEditing(true)
        } else {
            self.targetView.targetNumberTextField.becomeFirstResponder()
        }
    }
}
