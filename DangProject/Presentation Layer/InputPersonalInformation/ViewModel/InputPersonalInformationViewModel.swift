//
//  InputPersonalInformationViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/30.
//
import Foundation

import RxSwift
import RxRelay

protocol InputPersonalInformationViewModelInput {
    var heightObservable: PublishRelay<Int> { get }
    var weightObservable: PublishRelay<Int> { get }
    var sugarObservable: PublishRelay<Int> { get }
    var profileImageObservable: PublishRelay<UIImage> { get }
    var readyButtonIsValid: BehaviorRelay<Bool> { get }
    
    func pickerValueChanged(textFieldTag: Int, row: Int)
    func submitButtonTapped(name: String)
}

protocol InputPersonalInformationViewModelOutput {
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

protocol InputPersonalInformationViewModelProtocol: InputPersonalInformationViewModelInput, InputPersonalInformationViewModelOutput { }

class InputPersonalInformationViewModel: InputPersonalInformationViewModelProtocol {
    // MARK: - Init
    private let firebaseFireStoreUseCase: FirebaseFireStoreUseCase
    
    init(firebaseFireStoreUseCase: FirebaseFireStoreUseCase) {
        self.firebaseFireStoreUseCase = firebaseFireStoreUseCase
        checkReadyButtonIsValid()
    }
    
    private let disposeBag = DisposeBag()
    
    private func checkReadyButtonIsValid() {
        PublishRelay.combineLatest(heightObservable.asObservable(),
                                                weightObservable.asObservable(),
                                                sugarObservable.asObservable())
        .bind(onNext: { [unowned self] (height, weight, sugar) in
            readyButtonIsValid.accept(true)
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
    
    func submitButtonTapped(name: String) {
        guard let userDefaultsUid = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }
        let profile = ProfileDomainModel(uid: userDefaultsUid,
                                         name: name,
                                         height: heightValue,
                                         weight: weightValue,
                                         sugarLevel: sugarValue,
                                         profileImage: imageValue,
                                         onboarding: true,
                                         profileExistence: true)
        
        firebaseFireStoreUseCase.uploadProfile(profile: profile)
    }
}
