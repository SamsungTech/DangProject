//
//  LoginViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/27.
//

import AuthenticationServices
import CryptoKit
import Foundation

import RxSwift
import RxRelay


protocol LoginViewModelInput {
    func loginButtonDidTap(with viewController: UIViewController)
    func signIn(authorization: ASAuthorization)
}

protocol LoginViewModelOutput {
    var profileExistenceObservable: PublishRelay<Bool> { get }
    var checkAppVersionObservable: BehaviorRelay<Bool> { get }
    
    func retrieveEmail() -> String
}

protocol LoginViewModelProtocol: LoginViewModelInput, LoginViewModelOutput { }

class LoginViewModel: LoginViewModelProtocol {
    // MARK: - init
    private let manageFirebaseAuthUseCase: ManageFirebaseAuthUseCase
    private let manageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase
    private let disposeBag = DisposeBag()
    private var userEmail = ""
    
    init(manageFirebaseAuthUseCase: ManageFirebaseAuthUseCase,
         manageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase) {
        self.manageFirebaseAuthUseCase = manageFirebaseAuthUseCase
        self.manageFirebaseFireStoreUseCase = manageFirebaseFireStoreUseCase
    }
    
    //MARK: - Private Method
    fileprivate var currentNonce: String?
    
    func retrieveEmail() -> String {
        return userEmail
    }
    
    private func checkProfileExistence(uid: String) {
        manageFirebaseFireStoreUseCase.getProfileExistence(uid: uid)
            .subscribe(onNext: { [weak self] isExist in
                if isExist {
                    self?.profileExistenceObservable.accept(true)
                } else {
                    self?.manageFirebaseFireStoreUseCase.uploadFirebaseUID(uid: uid)
                    self?.profileExistenceObservable.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUserDefaultsUid(uid: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(uid, forKey: UserInfoKey.firebaseUID)
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
    
    //MARK: - Input
    func loginButtonDidTap(with viewController: UIViewController) {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = viewController as? ASAuthorizationControllerDelegate
        authorizationController.presentationContextProvider = viewController as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    func signIn(authorization: ASAuthorization) {
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
            guard let tokenString = String(data: appleIDToken, encoding: .utf8) else {
                return
            }
            
            let result = getEmailString(token: tokenString)
            
            userEmail = result
            
            manageFirebaseAuthUseCase.requireFirebaseUID(providerID: "apple.com",
                                                         idToken: idTokenString,
                                                         rawNonce: nonce)
            .subscribe(onNext: { [weak self] isValid, id in
                if isValid {
                    self?.updateUserDefaultsUid(uid: id)
                    self?.checkProfileExistence(uid: id)
                }
            })
            .disposed(by: disposeBag)
        }
    }
    
    //MARK: - Output
    let profileExistenceObservable = PublishRelay<Bool>()
    let checkAppVersionObservable = BehaviorRelay<Bool>(value: true)
}

extension LoginViewModel {
    private func getEmailString(token: String) -> String {
        let decodeToken = tokenDecode(token: token)
        var result = ""
        decodeToken.forEach { key, value in
            switch key {
            case "email": result = value as? String ?? ""
            default: break
            }
        }
        
        return result
    }
    
    private func tokenDecode(token: String) -> [String: Any] {
        
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")

            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }

        func decodePart(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value),
                  let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
            }

            return payload
        }
        
        let segments = token.components(separatedBy: ".")
        
        return decodePart(segments[1]) ?? [:]
    }
}
