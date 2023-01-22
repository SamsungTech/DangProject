//
//  InputPersonalInformationViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/30.
//
import Foundation
import UIKit

import RxSwift
import RxRelay

protocol InputProfileViewModelInput {
    var heightObservable: PublishRelay<Int> { get }
    var weightObservable: PublishRelay<Int> { get }
    var sugarObservable: PublishRelay<Int> { get }
    var profileImageObservable: PublishRelay<UIImage> { get }
    var readyButtonIsValid: BehaviorRelay<Bool> { get }
    
    func pickerValueChanged(textFieldTag: Int, row: Int)
    func submitButtonTapped(name: String, completion: @escaping (Bool) -> Void)
}

protocol InputProfileViewModelOutput {
    var loading: PublishRelay<LoadingState> { get }
    var heights: [String] { get }
    var weights: [String] { get }
    var sugars: [String] { get }
    
    var imageValue: UIImage { get }
    var heightValue: Int { get }
    var weightValue: Int { get }
    var sugarValue: Int { get }
    
    var numberOfComponents: [Int]  { get }
    var numberOfRowsInComponents: [[Int]] { get }
    var pickerViewValues: [[[String]]] { get }
    
    func changeProfileImage(image: UIImage?)
}

protocol InputProfileViewModelProtocol: InputProfileViewModelInput, InputProfileViewModelOutput { }

class InputProfileViewModel: InputProfileViewModelProtocol {
    // MARK: - Init
    private let profileManageUseCase: ProfileManagerUseCase
    private let manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase
    
    init(profileManageUseCase: ProfileManagerUseCase,
         manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase) {
        self.profileManageUseCase = profileManageUseCase
        self.manageFirebaseStorageUseCase = manageFirebaseStorageUseCase
        checkReadyButtonIsValid()
    }
    
    private let disposeBag = DisposeBag()
    
    private func checkReadyButtonIsValid() {
        PublishRelay.combineLatest(heightObservable.asObservable(),
                                   weightObservable.asObservable(),
                                   sugarObservable.asObservable(),
                                   profileImageObservable.asObservable())
        .bind(onNext: { [weak self] (height, weight, sugar, image) in
            self?.readyButtonIsValid.accept(true)
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    let heights: [String] = [Int](120...200).map{("\($0)")}
    let weights: [String] = [Int](30...150).map{("\($0)")}
    let sugars: [String] = ["10", "20", "30", "40", "50"]
    
    lazy var imageValue = UIImage()
    lazy var heightValue = Int()
    lazy var weightValue = Int()
    lazy var sugarValue = Int()
    
    let numberOfComponents: [Int] = [2,2,1]
    lazy var numberOfRowsInComponents: [[Int]] = [[heights.count, 1],[weights.count, 1],[sugars.count]]
    lazy var pickerViewValues: [[[String]]] = [[heights,["cm"]],[weights,["kg"]], [sugars]]
    let loading = PublishRelay<LoadingState>()
   
    func changeProfileImage(image: UIImage?) {
        guard let image = image else { return }
        imageValue = image
        profileImageObservable.accept(imageValue)
    }
    
    // MARK: - Input
    var heightObservable = PublishRelay<Int>()
    var weightObservable = PublishRelay<Int>()
    var sugarObservable = PublishRelay<Int>()
    var profileImageObservable = PublishRelay<UIImage>()
    var readyButtonIsValid = BehaviorRelay(value: false)
    
    
    func pickerValueChanged(textFieldTag: Int, row: Int) {
        
        switch textFieldTag {
        case 0:
            heightValue = Int(heights[row])!
            heightObservable.accept(heightValue)
        case 1:
            weightValue = Int(weights[row])!
            weightObservable.accept(weightValue)
        case 2:
            sugarValue = Int(sugars[row])!
            sugarObservable.accept(sugarValue)
        default:
            break
        }
    }
    
    func submitButtonTapped(name: String,
                            completion: @escaping (Bool) -> Void) {
        guard let userDefaultsUid = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }
        let profile = ProfileDomainModel(uid: userDefaultsUid,
                                         name: name,
                                         height: heightValue,
                                         weight: weightValue,
                                         sugarLevel: sugarValue,
                                         profileImage: imageValue)
        guard let jpegData = profile.profileImage.jpegData(compressionQuality: 0.8) else { return }
        manageFirebaseStorageUseCase.uploadProfileImage(data: jpegData) { bool in
            if bool {
                self.profileManageUseCase.saveProfileOnRemoteData(profile, completion: completion)
            } else {
                completion(false)
            }
        }
    }
}
