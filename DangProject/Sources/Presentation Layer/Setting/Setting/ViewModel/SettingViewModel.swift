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
    func fetchUserName() -> String
    func fetchUserImage() -> UIImage
}

protocol SettingViewModelProtocol: SettingViewModelInputProtocol, SettingViewModelOutputProtocol {}

class SettingViewModel: SettingViewModelProtocol {
    private var disposeBag = DisposeBag()
    var scrollStateRelay = BehaviorRelay<SettingScrollState>(value: .top)
    private let fetchProfileUseCase: FetchProfileUseCase
    
    init(fetchProfileUseCase: FetchProfileUseCase) {
        self.fetchProfileUseCase = fetchProfileUseCase
    }
    
    // MARK: - Output
    func fetchUserName() -> String {
        var result = ""
        fetchProfileUseCase.fetchProfileData()
            .map({ $0.name })
            .subscribe(onNext: { name in
                result = name
            })
            .disposed(by: disposeBag)
        
        return result
    }
    
    func fetchUserImage() -> UIImage {
        var result = UIImage()
        fetchProfileUseCase.fetchProfileData()
            .map({ $0.profileImage })
            .subscribe(onNext: { image in
                result = image
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
