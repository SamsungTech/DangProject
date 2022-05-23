//
//  MyTargetViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import Foundation
import RxSwift

protocol MyTargetViewModelInputProtocol: AnyObject {
    
}

protocol MyTargetViewModelOutputProtocol: AnyObject {
    
}

protocol MyTargetViewModelProtocol: MyTargetViewModelInputProtocol, MyTargetViewModelOutputProtocol {}

class MyTargetViewModel: MyTargetViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    init() {}
}

extension MyTargetViewModel {
    
}
