//
//  SettingViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import Foundation
import UIKit

import RxSwift
import RxRelay

enum SettingScrollState {
    case top
    case scrolling
}

protocol SettingViewModelInputProtocol: AnyObject {
    func checkScrollValue(_ yValue: CGFloat)
}

protocol SettingViewModelOutputProtocol: AnyObject {
    var scrollStateRelay: BehaviorRelay<SettingScrollState> { get }
    func fetchUserNameAndImage() -> (String, UIImage)
}

protocol SettingViewModelProtocol: SettingViewModelInputProtocol, SettingViewModelOutputProtocol {}

class SettingViewModel: SettingViewModelProtocol {
    private var disposeBag = DisposeBag()
    var scrollStateRelay = BehaviorRelay<SettingScrollState>(value: .top)
    private let profileManagerUseCase: ProfileManagerUseCase
    
    init(profileManagerUseCase: ProfileManagerUseCase) {
        self.profileManagerUseCase = profileManagerUseCase
    }
    
    // MARK: - Output
    
    func fetchUserNameAndImage() -> (String, UIImage) {
        var result: (String, UIImage) = ("", UIImage())
        profileManagerUseCase.fetchProfileData()
            .subscribe(onNext: { profile in
                result = (profile.name, profile.profileImage)
            })
            .disposed(by: disposeBag)
        return result
    }
    
}

extension SettingViewModel {
    func checkScrollValue(_ yValue: CGFloat) {
        if yValue < 1 {
            scrollStateRelay.accept(.top)
        } else {
            scrollStateRelay.accept(.scrolling)
        }
    }
}
