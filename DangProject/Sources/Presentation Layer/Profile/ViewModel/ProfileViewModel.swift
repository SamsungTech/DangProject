//
//  ProfileViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import UIKit

import RxSwift
import RxRelay

enum ScrollState {
    case top
    case scrolling
}

enum GenderType {
    case none
    case male
    case female
}

enum LoadingState {
    case startLoading
    case finishLoading
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
    func saveProfile(_ data: ProfileDomainModel)
}

protocol ProfileViewModelOutputProtocol {
    var heights: [String] { get }
    var weights: [String] { get }
    var scrollValue: BehaviorRelay<ScrollState> { get }
    var genderRelay: BehaviorRelay<GenderType> { get }
    var profileDataRelay: BehaviorRelay<ProfileData> { get }
    var loadingRelay: PublishRelay<LoadingState> { get }
    func convertGenderTypeToString() -> String
}

protocol ProfileViewModelProtocol: ProfileViewModelInputProtocol, ProfileViewModelOutputProtocol {
    
}

class ProfileViewModel: ProfileViewModelProtocol {
    private var manageFirebaseStoreUseCase: ManageFirebaseFireStoreUseCase
    private let manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase
    private let profileManagerUseCase: ProfileManagerUseCase
    private let disposeBag = DisposeBag()
    var scrollValue = BehaviorRelay<ScrollState>(value: .top)
    var genderRelay = BehaviorRelay<GenderType>(value: .none)
    var profileDataRelay = BehaviorRelay<ProfileData>(value: .empty)
    let heights: [String] = [Int](1...200).map{("\($0)")}
    let weights: [String] = [Int](1...150).map{("\($0)")}
    let loadingRelay = PublishRelay<LoadingState>()
    
    init(manageFirebaseStoreUseCase: ManageFirebaseFireStoreUseCase,
         manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase,
         profileManagerUseCase: ProfileManagerUseCase) {
        self.manageFirebaseStoreUseCase = manageFirebaseStoreUseCase
        self.manageFirebaseStorageUseCase = manageFirebaseStorageUseCase
        self.profileManagerUseCase = profileManagerUseCase
        fetchProfile()
    }
    
    private func fetchProfile() {
        profileManagerUseCase.fetchProfileData()
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
    
    func saveProfile(_ profile: ProfileDomainModel) {
        loadingRelay.accept(.startLoading)
        guard let jpegData = profile.profileImage.jpegData(compressionQuality: 0.8) else { return }
        manageFirebaseStoreUseCase.updateProfileData(profile)
        manageFirebaseStorageUseCase.updateProfileImage(jpegData)
            .subscribe(onNext: { [weak self] isUpdated in
                if isUpdated {
                    self?.profileManagerUseCase.saveProfileOnCoreData(profile)
                    self?.loadingRelay.accept(.finishLoading)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func calculateScrollViewState(yPosition: CGFloat) {
        if yPosition <= 0 {
            scrollValue.accept(.top)
        } else {
            scrollValue.accept(.scrolling)
        }
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
