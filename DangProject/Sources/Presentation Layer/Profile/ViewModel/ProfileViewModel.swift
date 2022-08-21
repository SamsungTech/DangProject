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

protocol ProfileViewModelInputProtocol {
    func calculateScrollViewState(yPosition: CGFloat)
    func saveProfile(_ data: ProfileDomainModel)
}

protocol ProfileViewModelOutputProtocol {
    var heights: [String] { get }
    var weights: [String] { get }
    var scrollValue: BehaviorRelay<ScrollState> { get }
    var genderRelay: BehaviorRelay<GenderType> { get }
    var profileDataRelay: BehaviorRelay<ProfileDomainModel> { get }
    var loadingRelay: PublishRelay<LoadingState> { get }
    func convertGenderTypeToString() -> String
    func getHeightSelectRowIndex(_ height: Int) -> Int
    func getWeightSelectRowIndex(_ weight: Int) -> Int
    func convertBirthDateToString(_ date: Date) -> String
    func convertBirthStringToDate(_ dateString: String) -> Date
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
    var profileDataRelay = BehaviorRelay<ProfileDomainModel>(value: .empty)
    let heights: [String] = [Int](50...200).map{("\($0)")}
    let weights: [String] = [Int](30...150).map{("\($0)")}
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
                self?.profileDataRelay.accept(profile)
            })
            .disposed(by: disposeBag)
    }
    
    func getHeightSelectRowIndex(_ height: Int) -> Int {
        return heights.firstIndex(of: String(height)) ?? 0
    }
    
    func getWeightSelectRowIndex(_ weight: Int) -> Int {
        return weights.firstIndex(of: String(weight)) ?? 0
    }
    
    func convertBirthDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: date)
    }
    
    func convertBirthStringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.date(from: dateString) ?? Date.init()
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
