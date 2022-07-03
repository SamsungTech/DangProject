//
//  ProfileViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import UIKit

import RxSwift
import RxRelay

enum SaveButtonState {
    case up
    case down
    case none
}

enum TextFieldType {
    case none
    case name
    case birthDate
    case height
    case weight
}

enum ScrollState {
    case top
    case scrolling
}

enum GenderType {
    case none
    case male
    case female
}

struct ProfileData {
    var profileImage: UIImage
    var uid: String
    var name: String
    var height: Int
    var weight: Int
    var sugarLevel: Int
    var gender: String
    var birthDay: String

    init(_ image: UIImage,
         _ profileDomainModel: ProfileDomainModel) {
        self.profileImage = image
        self.uid = profileDomainModel.uid
        self.name = profileDomainModel.name
        self.height = profileDomainModel.height
        self.weight = profileDomainModel.weight
        self.sugarLevel = profileDomainModel.sugarLevel
        self.gender = profileDomainModel.gender
        self.birthDay = profileDomainModel.birthDay
    }
}

protocol ProfileViewModelInputProtocol {
    func viewDidLoad()
    func calculateScrollViewState(yPosition: CGFloat)
    func saveButtonDidTap()
    func passProfileData(_ data: ProfileDomainModel)
    func passProfileImageData(_ data: UIImage)
}

protocol ProfileViewModelOutputProtocol {
    var scrollValue: BehaviorRelay<ScrollState> { get }
    var genderRelay: BehaviorRelay<GenderType> { get }
    var saveButtonAnimationRelay: BehaviorRelay<SaveButtonState> { get }
    var okButtonRelay: BehaviorRelay<TextFieldType> { get }
    var profileDataSubject: PublishSubject<ProfileData> { get }
    func convertGenderTypeToString() -> String
}

protocol ProfileViewModelProtocol: ProfileViewModelInputProtocol, ProfileViewModelOutputProtocol {
    
}

class ProfileViewModel: ProfileViewModelProtocol {
    private var firebaseStoreUseCase: FirebaseFireStoreUseCase?
    private let firebaseStorageUseCase: FirebaseStorageUseCase?
    private let disposeBag = DisposeBag()
    var scrollValue = BehaviorRelay<ScrollState>(value: .top)
    var genderRelay = BehaviorRelay<GenderType>(value: .none)
    var saveButtonAnimationRelay = BehaviorRelay<SaveButtonState>(value: .none)
    var okButtonRelay = BehaviorRelay<TextFieldType>(value: .none)
    var profileDataSubject = PublishSubject<ProfileData>()
    
    init(firebaseStoreUseCase: FirebaseFireStoreUseCase,
         firebaseStorageUseCase: FirebaseStorageUseCase) {
        self.firebaseStoreUseCase = firebaseStoreUseCase
        self.firebaseStorageUseCase = firebaseStorageUseCase
    }
    
    func viewDidLoad() {
        guard let profileImage = firebaseStorageUseCase?.getProfileImage() else { return }
        guard let profileData = firebaseStoreUseCase?.getProfileData() else { return }
        
        Observable.combineLatest(profileImage, profileData)
            .subscribe(onNext: { [weak self] imageData, profileData in
                guard let image = UIImage(data: imageData as Data) else { return }
                let profile = ProfileData(image,
                                          profileData)
                self?.convertStringToGenderType(profileData.gender)
                self?.profileDataSubject.onNext(profile)
            })
            .disposed(by: disposeBag)
        
    }
    
    func convertGenderTypeToString() -> String {
        switch genderRelay.value {
        case .none:
            return ""
        case .male:
            return "남자"
        case .female:
            return "여자"
        }
    }
    
    func passProfileData(_ data: ProfileDomainModel) {
        firebaseStoreUseCase?.updateProfileData(data)
    }
    
    func calculateScrollViewState(yPosition: CGFloat) {
        if yPosition <= 0 {
            scrollValue.accept(.top)
        } else {
            scrollValue.accept(.scrolling)
        }
    }
    
    func saveButtonDidTap() {
        if saveButtonAnimationRelay.value == .up || saveButtonAnimationRelay.value == .none {
            saveButtonAnimationRelay.accept(.down)
        } else {
            saveButtonAnimationRelay.accept(.up)
        }
    }
    
    func passProfileImageData(_ data: UIImage) {
        guard let data = data.jpegData(compressionQuality: 0.8) else { return }
        firebaseStorageUseCase?.upDateProfileImage(data)
    }

    private func convertStringToGenderType(_ data: String) {
        switch data {
        case "남자":
            genderRelay.accept(.male)
        case "여자":
            genderRelay.accept(.female)
        default:
            break
        }
    }
}
