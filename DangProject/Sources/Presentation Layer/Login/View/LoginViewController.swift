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
        setupAppleLoginButton()
        bindSignInObservable()
    }
    
    private func setupAppleLoginButton() {
        if #available(iOS 13.0, *) {
            let appleLoginButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
            self.view.addSubview(appleLoginButton)
            appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                appleLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                appleLoginButton.topAnchor.constraint(equalTo: view.topAnchor,
                                                      constant: self.view.yValueRatio(650)),
                appleLoginButton.widthAnchor.constraint(equalToConstant: self.view.xValueRatio(300)),
                appleLoginButton.heightAnchor.constraint(equalToConstant: self.view.yValueRatio(70))
            ])
            appleLoginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        }
    }
    
    private func bindSignInObservable() {
        viewModel.profileExistenceObservable
            .bind(onNext: { [weak self] profileIsValid in
                if profileIsValid {
                    self?.coordinatorFinishDelegate?.switchViewController(to: .tabBar)
                } else {
                    self?.coordinatorFinishDelegate?.switchViewController(to: .inputPersonalInformation)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        viewModel.loginButtonDidTap(with: self)
    }
    
}
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        viewModel.signIn(authorization: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
}
