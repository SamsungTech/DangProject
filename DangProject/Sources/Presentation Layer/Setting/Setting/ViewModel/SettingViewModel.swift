//
//  SettingViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import Foundation
import UIKit

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
}

protocol SettingViewModelProtocol: SettingViewModelInputProtocol, SettingViewModelOutputProtocol {}

class SettingViewModel: SettingViewModelProtocol {
    private var settingUseCase: DefaultAlarmManagerUseCase?
    var scrollStateRelay = BehaviorRelay<SettingScrollState>(value: .top)
    
    init(settingUseCase: DefaultAlarmManagerUseCase) {
        self.settingUseCase = settingUseCase
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
