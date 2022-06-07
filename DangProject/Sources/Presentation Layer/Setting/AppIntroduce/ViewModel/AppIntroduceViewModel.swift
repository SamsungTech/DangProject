//
//  AppIntroduceViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import Foundation

protocol AppIntroduceViewModelInputProtocol: AnyObject {
    
}

protocol AppIntroduceViewModelOutputProtocol: AnyObject {
    
}

protocol AppIntroduceViewModelProtocol: AppIntroduceViewModelInputProtocol, AppIntroduceViewModelOutputProtocol {}

class AppIntroduceViewModel: AppIntroduceViewModelProtocol {
    init() {}
}
