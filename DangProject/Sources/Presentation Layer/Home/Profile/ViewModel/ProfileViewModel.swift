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
    case targetSugar
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

protocol ProfileViewModelInputProtocol {
    func viewDidLoad()
    func calculateScrollViewState(yPosition: CGFloat)
    func saveButtonDidTap()
    func passProfileData(_ data: ProfileDomainModel)
}

protocol ProfileViewModelOutputProtocol {
    var scrollValue: BehaviorRelay<ScrollState> { get }
    var genderRelay: BehaviorRelay<GenderType> { get }
    var saveButtonAnimationRelay: BehaviorRelay<SaveButtonState> { get }
    var okButtonRelay: BehaviorRelay<TextFieldType> { get }
    var profileDataRelay: BehaviorRelay<ProfileDomainModel> { get }
    func convertGenderTypeToString() -> String
}

protocol ProfileViewModelProtocol: ProfileViewModelInputProtocol, ProfileViewModelOutputProtocol {
    
}

class ProfileViewModel: ProfileViewModelProtocol {
    private var firebaseStoreUseCase: FirebaseFireStoreUseCase?
    private let disposeBag = DisposeBag()
    var scrollValue = BehaviorRelay<ScrollState>(value: .top)
    var genderRelay = BehaviorRelay<GenderType>(value: .none)
    var saveButtonAnimationRelay = BehaviorRelay<SaveButtonState>(value: .none)
    var okButtonRelay = BehaviorRelay<TextFieldType>(value: .none)
    var profileDataRelay = BehaviorRelay<ProfileDomainModel>(value: .empty)
    
    init(useCase: FirebaseFireStoreUseCase) {
        self.firebaseStoreUseCase = useCase
    }
    
    func viewDidLoad() {
        firebaseStoreUseCase?.getProfileData()
            .subscribe(onNext: { [weak self] profileData in
                self?.convertStringToGenderType(profileData.gender)
                self?.profileDataRelay.accept(profileData)
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
