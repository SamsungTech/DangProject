//
//  ThemeViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import Foundation

import RxSwift
import RxRelay

enum Mode {
    case rightMode
    case darkMode
    case systemMode
    case none
}

protocol ThemeViewModelInputProtocol: AnyObject {
    
}

protocol ThemeViewModelOutputProtocol: AnyObject {
    
}

protocol ThemeViewModelProtocol: ThemeViewModelInputProtocol, ThemeViewModelOutputProtocol {
    
}

class ThemeViewModel: ThemeViewModelProtocol {
    private let disposeBag = DisposeBag()
    var displayModeRelay = BehaviorRelay<Mode>(value: .none)
    
    init() {}
}
