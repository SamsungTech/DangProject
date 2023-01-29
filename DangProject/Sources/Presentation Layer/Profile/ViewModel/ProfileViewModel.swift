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

enum LoadingState {
    case startLoading
    case finishLoading
}

protocol ProfileViewModelInputProtocol {
    func calculateScrollViewState(yPosition: CGFloat)
    func saveProfile(_ data: ProfileDomainModel,
                     completion: @escaping (Bool) -> Void)
    func fetchProfileData()
}

protocol ProfileViewModelOutputProtocol {
    var heights: [String] { get }
    var weights: [String] { get }
    var scrollValue: BehaviorRelay<ScrollState> { get }
    var profileDataRelay: BehaviorRelay<ProfileDomainModel> { get }
    var loadingRelay: PublishRelay<LoadingState> { get }
    var profileIsFirstShowing: Bool { get }
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
    var profileDataRelay = BehaviorRelay<ProfileDomainModel>(value: .empty)
    let heights: [String] = [Int](50...200).map{("\($0)")}
    let weights: [String] = [Int](30...150).map{("\($0)")}
    let loadingRelay = PublishRelay<LoadingState>()
    var profileIsFirstShowing: Bool = true
    
    init(manageFirebaseStoreUseCase: ManageFirebaseFireStoreUseCase,
         manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase,
         profileManagerUseCase: ProfileManagerUseCase) {
        self.manageFirebaseStoreUseCase = manageFirebaseStoreUseCase
        self.manageFirebaseStorageUseCase = manageFirebaseStorageUseCase
        self.profileManagerUseCase = profileManagerUseCase
        bindProfileData()
    }
    
    func fetchProfileData() {
        profileManagerUseCase.fetchProfileData()
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
    
    // MARK: - Input
    
    func saveProfile(_ profile: ProfileDomainModel,
                     completion: @escaping (Bool) -> Void) {
        loadingRelay.accept(.startLoading)
        guard let jpegData = profile.profileImage.jpegData(compressionQuality: 0.8) else { return }
        manageFirebaseStoreUseCase.uploadProfile(profile: profile) { [weak self] isDone in
            if isDone {
                self?.saveProfileImageInStorage(data: jpegData, profile: profile, completion: completion)
            } else {
                completion(false)
            }
        }
        
    }
    
    private func saveProfileImageInStorage(data: Data,
                                           profile: ProfileDomainModel,
                                           completion: @escaping(Bool)->Void) {
        manageFirebaseStorageUseCase.uploadProfileImage(data: data) { [weak self] isDone in
            if isDone {
                self?.profileManagerUseCase.saveProfileOnRemoteData(profile, completion: completion)
                self?.loadingRelay.accept(.finishLoading)
            } else {
                completion(false)
            }
        }
    }
    
    func calculateScrollViewState(yPosition: CGFloat) {
        if yPosition <= 0 {
            scrollValue.accept(.top)
        } else {
            scrollValue.accept(.scrolling)
        }
    }
    
    private func bindProfileData() {
        profileManagerUseCase.profileDataObservable
            .subscribe(onNext: { [weak self] profile in
                self?.profileDataRelay.accept(profile)
            })
            .disposed(by: disposeBag)
    }
    
}
