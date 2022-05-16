//
//  LoginViewController.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/27.
//

import AuthenticationServices
import CryptoKit
import Foundation
import UIKit

import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    let viewModel: LoginViewModel
    fileprivate var currentNonce: String?
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    
    let disposBag = DisposeBag()
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
            .bind(onNext: { [unowned self] profileIsValid in
                if profileIsValid {
                    coordinatorFinishDelegate?.switchViewController(to: .tabBar)
                } else {
                    coordinatorFinishDelegate?.switchViewController(to: .inputPersonalInformation)
                }
            })
            .disposed(by: disposBag)
    }
    
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    
}
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            viewModel.signIn(providerID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print("Sign in with Apple errored: \(error)")
    }
}
