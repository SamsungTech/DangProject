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
    var profileDataRelay: BehaviorRelay<(UIImage, String)> { get }
}

protocol SettingViewModelProtocol: SettingViewModelInputProtocol, SettingViewModelOutputProtocol {}

class SettingViewModel: SettingViewModelProtocol {
    private var disposeBag = DisposeBag()
    private let profileManagerUseCase: ProfileManagerUseCase
    var scrollStateRelay = BehaviorRelay<SettingScrollState>(value: .top)
    var profileDataRelay = BehaviorRelay<(UIImage, String)>(value: (UIImage(), ""))
    
    init(profileManagerUseCase: ProfileManagerUseCase) {
        self.profileManagerUseCase = profileManagerUseCase
        self.bindProfileData()
    }
    
    // MARK: - Output
    
    func fetchUserNameAndImage() {
        profileManagerUseCase.fetchProfileData()
    }
    
    private func bindProfileData() {
        profileManagerUseCase.profileDataObservable
            .subscribe(onNext: { [weak self] profileData in
                self?.profileDataRelay.accept((profileData.profileImage, profileData.name))
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
