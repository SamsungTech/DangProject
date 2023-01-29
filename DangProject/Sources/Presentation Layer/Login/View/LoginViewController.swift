//
//  LoginViewController.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/27.
//

import AuthenticationServices
import Foundation
import UIKit

import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    private let disposeBag = DisposeBag()
    weak var coordinator: LoginCoordinator?
    private let viewModel: LoginViewModel
    
    private lazy var loginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppImage2")
        return imageView
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Dang Project"
        label.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .heavy)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .black)
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    
    // MARK: - Init
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginImageView()
        setupLoginLabel()
        setupAppleLoginButton()
        bindSignInObservable()
        bindCheckAppVersionObservable()
    }
    
    private func setupLoginImageView() {
        view.addSubview(loginImageView)
        loginImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -yValueRatio(50)),
            loginImageView.widthAnchor.constraint(equalToConstant: xValueRatio(150)),
            loginImageView.heightAnchor.constraint(equalToConstant: yValueRatio(150))
        ])
    }
    
    private func setupLoginLabel() {
        view.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: loginImageView.bottomAnchor)
        ])
    }
    
    private func setupAppleLoginButton() {
        self.view.addSubview(appleLoginButton)
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            appleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: self.view.yValueRatio(650)),
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xValueRatio(20)),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xValueRatio(20)),
            appleLoginButton.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(50))
        ])
        
    }
    
    private func bindSignInObservable() {
        viewModel.profileExistenceObservable
            .bind(onNext: { [weak self] profileIsValid in
                guard let email = self?.viewModel.retrieveEmail() else { return }
                if profileIsValid {
//                    self?.coordinatorFinishDelegate?.switchViewController(to: .tabBar)
                    self?.coordinatorFinishDelegate?.switchViewController(to: .inputPersonalInformation(email: email))
                } else {
                    self?.coordinatorFinishDelegate?.switchViewController(to: .inputPersonalInformation(email: email))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCheckAppVersionObservable() {
        viewModel.checkAppVersionObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.presentDelay()
            })
            .disposed(by: disposeBag)
    }
    
    private func presentDelay() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.coordinator?.presentUpdateAlertViewFromLoginView()
            self.appleLoginButton.isEnabled = true
        }
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: "오류",
                                      message: "Apple login - 실패, 인터넷 연결 확인을 확인해주세요",
                                      preferredStyle: UIAlertController.Style.alert)
        let actionButton = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: false)
        }
        alert.addAction(actionButton)
        return alert
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        viewModel.loginButtonDidTap(with: self)
    }
    
}
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.view.window else { return ASPresentationAnchor() }
        return window
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        viewModel.signIn(authorization: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
        let alert = createAlert()
        present(alert, animated: false)
    }
}
