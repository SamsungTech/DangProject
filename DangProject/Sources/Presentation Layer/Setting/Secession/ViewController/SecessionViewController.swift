//
//  SecessionViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import UIKit
import RxSwift

class SecessionViewController: CustomViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SecessionViewModel
    weak var coordinator: SecessionCoordinator?
    
    private lazy var navigationBar: CommonNavigationBar = {
        let navigationBar = CommonNavigationBar()
        navigationBar.accountTitleLabel.text = "탈퇴"
        return navigationBar
    }()
    
    private var waningView = WarningView()
    
    private lazy var resignButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .homeBoxColor
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.setTitle("탈퇴하기", for: .normal)
        return button
    }()
    
    private lazy var resignAlertController: UIAlertController = {
        let alert = UIAlertController(title: "정말 탈퇴하시겠습니까?", message: nil, preferredStyle: .alert)
        return alert
    }()
    
    private lazy var loadingView = LoadingView(frame: .zero)
    
    init(viewModel: SecessionViewModel) {
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

extension SecessionViewController {
    private func configureUI() {
        setUpView()
        setUpNavigationBar()
        setUpWaningView()
        setUpDeleteButton()
        setupResignAlertController()
        setupLoadingView()
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
        view.addSubview(resignButton)
        resignButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resignButton.topAnchor.constraint(equalTo: waningView.bottomAnchor, constant: yValueRatio(30)),
            resignButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resignButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resignButton.heightAnchor.constraint(equalToConstant: yValueRatio(60))
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
    
    private func setupResignAlertController() {
        let no = UIAlertAction(title: "취소", style: .default, handler: nil)
        let yes = UIAlertAction(title: "탈퇴", style: .destructive) { [weak self] _ in
            self?.viewModel.loading.accept(.startLoading)
            self?.viewModel.resignUser { bool in
                if bool {
                    self?.viewModel.loading.accept(.finishLoading)
                    self?.viewModel.removeFirebaseUID()
                    self?.coordinator?.returnToFirstStart()
                } else {
                    guard let alert = self?.createAlert() else { return }
                    self?.present(alert, animated: false)
                }
            }
        }
        resignAlertController.addAction(yes)
        resignAlertController.addAction(no)
    }
    
    private func bindUI() {
        navigationBar.backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.popSecessionViewController()
            }
            .disposed(by: disposeBag)
        
        resignButton.rx.tap
            .bind { [weak self] in
                guard let strongSelf = self else { return }
                self?.present(strongSelf.resignAlertController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        viewModel.loading
            .bind { [weak self] state in
                switch state {
                case .startLoading:
                    self?.loadingView.showLoading()
                case .finishLoading:
                    self?.loadingView.hideLoading()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: "오류",
                                      message: "firebaseServer 연결 오류 - 탈퇴 실패",
                                      preferredStyle: UIAlertController.Style.alert)
        let actionButton = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: false)
        }
        alert.addAction(actionButton)
        return alert
    }
}
