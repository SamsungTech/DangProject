//
//  ProfileViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import Foundation
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
}

protocol ProfileViewModelOutputProtocol {
    var scrollValue: BehaviorRelay<ScrollState> { get }
    var genderRelay: BehaviorRelay<GenderType> { get }
    var saveButtonAnimationRelay: BehaviorRelay<SaveButtonState> { get }
    var okButtonRelay: BehaviorRelay<TextFieldType> { get }
}

protocol ProfileViewModelProtocol: ProfileViewModelInputProtocol, ProfileViewModelOutputProtocol {
    
}

class ProfileViewModel: ProfileViewModelProtocol {
    private var profileUseCase: ProfileUseCaseProtocol?
    var scrollValue = BehaviorRelay<ScrollState>(value: .top)
    var genderRelay = BehaviorRelay<GenderType>(value: .none)
    var saveButtonAnimationRelay = BehaviorRelay<SaveButtonState>(value: .none)
    var okButtonRelay = BehaviorRelay<TextFieldType>(value: .none)
    
    init(useCase: ProfileUseCaseProtocol) {
        self.profileUseCase = useCase
    }
    
    func viewDidLoad() {
        
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
    
    
}
