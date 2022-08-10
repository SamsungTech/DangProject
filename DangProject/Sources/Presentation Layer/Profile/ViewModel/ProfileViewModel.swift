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
    static let empty: Self = .init(ProfileDomainModel.empty)
    var profileImage: UIImage
    var uid: String
    var name: String
    var height: Int
    var weight: Int
    var sugarLevel: Int
    var gender: String
    var birthday: String

    init(_ profileDomainModel: ProfileDomainModel) {
        self.profileImage = profileDomainModel.profileImage
        self.uid = profileDomainModel.uid
        self.name = profileDomainModel.name
        self.height = profileDomainModel.height
        self.weight = profileDomainModel.weight
        self.sugarLevel = profileDomainModel.sugarLevel
        self.gender = profileDomainModel.gender
        self.birthday = profileDomainModel.birthday
    }
}

protocol ProfileViewModelInputProtocol {
    func calculateScrollViewState(yPosition: CGFloat)
    func switchSaveButtonRelayValue()
    func handOverProfileDataToSave(_ data: ProfileDomainModel)
    func handOverProfileImageDataToSave(_ data: UIImage)
}

protocol ProfileViewModelOutputProtocol {
    var heights: [String] { get }
    var weights: [String] { get }
    
    var scrollValue: BehaviorRelay<ScrollState> { get }
    var genderRelay: BehaviorRelay<GenderType> { get }
    var saveButtonAnimationRelay: BehaviorRelay<SaveButtonState> { get }
    var okButtonRelay: BehaviorRelay<TextFieldType> { get }
    var profileDataRelay: BehaviorRelay<ProfileData> { get }
    func convertGenderTypeToString() -> String
}

protocol ProfileViewModelProtocol: ProfileViewModelInputProtocol, ProfileViewModelOutputProtocol {
    
}

class ProfileViewModel: ProfileViewModelProtocol {
    private var manageFirebaseStoreUseCase: ManageFirebaseFireStoreUseCase
    private let manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase
    private let fetchProfileUseCase: FetchProfileUseCase
    private let disposeBag = DisposeBag()
    var scrollValue = BehaviorRelay<ScrollState>(value: .top)
    var genderRelay = BehaviorRelay<GenderType>(value: .none)
    var saveButtonAnimationRelay = BehaviorRelay<SaveButtonState>(value: .none)
    var okButtonRelay = BehaviorRelay<TextFieldType>(value: .none)
    var profileDataRelay = BehaviorRelay<ProfileData>(value: .empty)
    let heights: [String] = [Int](1...200).map{("\($0)")}
    let weights: [String] = [Int](1...150).map{("\($0)")}
    
    init(manageFirebaseStoreUseCase: ManageFirebaseFireStoreUseCase,
         manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase,
         fetchProfileUseCase: FetchProfileUseCase) {
        self.manageFirebaseStoreUseCase = manageFirebaseStoreUseCase
        self.manageFirebaseStorageUseCase = manageFirebaseStorageUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        fetchProfile()
    }
    
    private func fetchProfile() {
        fetchProfileUseCase.fetchProfileData()
            .subscribe(onNext: { [weak self] profile in
                self?.profileDataRelay.accept(ProfileData.init(profile))
            })
            .disposed(by: disposeBag)
    }
    
    func convertGenderTypeToString() -> String {
        switch genderRelay.value {
        case .none:
            return "에러"
        case .male:
            return "남자"
        case .female:
            return "여자"
        }
    }
    
    func handOverProfileDataToSave(_ data: ProfileDomainModel) {
        manageFirebaseStoreUseCase.updateProfileData(data)
    }
    
    func calculateScrollViewState(yPosition: CGFloat) {
        if yPosition <= 0 {
            scrollValue.accept(.top)
        } else {
            scrollValue.accept(.scrolling)
        }
    }
    
    func switchSaveButtonRelayValue() {
        if saveButtonAnimationRelay.value == .up || saveButtonAnimationRelay.value == .none {
            saveButtonAnimationRelay.accept(.down)
        } else {
            saveButtonAnimationRelay.accept(.up)
        }
    }
    
    func handOverProfileImageDataToSave(_ data: UIImage) {
        guard let data = data.jpegData(compressionQuality: 0.8) else { return }
        manageFirebaseStorageUseCase.updateProfileImage(data)
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
