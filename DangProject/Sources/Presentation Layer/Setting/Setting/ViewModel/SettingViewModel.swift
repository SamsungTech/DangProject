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
    func fetchUserNameAndImage()
}

protocol SettingViewModelOutputProtocol: AnyObject {
    var scrollStateRelay: BehaviorRelay<SettingScrollState> { get }
    var settingDataRelay: BehaviorRelay<(String, UIImage)> { get }
}

protocol SettingViewModelProtocol: SettingViewModelInputProtocol, SettingViewModelOutputProtocol {}

class SettingViewModel: SettingViewModelProtocol {
    private var disposeBag = DisposeBag()
    private let profileManagerUseCase: ProfileManagerUseCase
    
    var settingDataRelay = BehaviorRelay<(String, UIImage)>(value: ("", UIImage()))
    var scrollStateRelay = BehaviorRelay<SettingScrollState>(value: .top)
    
    init(profileManagerUseCase: ProfileManagerUseCase) {
        self.profileManagerUseCase = profileManagerUseCase
        self.bindUserNameAndImage()
    }
    
    func fetchUserNameAndImage() {
        profileManagerUseCase.fetchProfileData()
    }
    
    private func bindUserNameAndImage() {
        profileManagerUseCase.profileDataObservable
            .subscribe(onNext: { [weak self] profile in
                let result = (profile.name, profile.profileImage)
                self?.settingDataRelay.accept(result)
            })
            .disposed(by: disposeBag)
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
