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
    func fetchProfileData()
}

protocol SettingViewModelOutputProtocol: AnyObject {
    var scrollStateRelay: BehaviorRelay<SettingScrollState> { get }
    var profileDataRelay: BehaviorRelay<ProfileDomainModel> { get }
}

protocol SettingViewModelProtocol: SettingViewModelInputProtocol, SettingViewModelOutputProtocol {}

class SettingViewModel: SettingViewModelProtocol {
    private let fetchProfileUseCase: FetchProfileUseCase
    private let disposeBag = DisposeBag()
    var profileDataRelay = BehaviorRelay<ProfileDomainModel>(value: .empty)
    var scrollStateRelay = BehaviorRelay<SettingScrollState>(value: .top)
    
    init(fetchProfileUseCase: FetchProfileUseCase) {
        self.fetchProfileUseCase = fetchProfileUseCase
        bindProfileData()
    }
    
    func fetchProfileData() {
        fetchProfileUseCase.fetchProfileData()
    }
    
    private func bindProfileData() {
        fetchProfileUseCase.profileDataSubject
            .subscribe(onNext: { [weak self] profileData in
                self?.profileDataRelay.accept(profileData)
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
