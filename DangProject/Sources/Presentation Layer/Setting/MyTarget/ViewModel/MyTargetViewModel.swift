//
//  MyTargetViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import Foundation
import RxSwift
import RxRelay

protocol MyTargetViewModelInputProtocol: AnyObject {
    func setCurrentTargetSugar(_ data: Int)
    func getCurrentTargetSugar()
}

protocol MyTargetViewModelOutputProtocol: AnyObject {
    var targetSugarRelay: BehaviorRelay<Int> { get }
}

protocol MyTargetViewModelProtocol: MyTargetViewModelInputProtocol, MyTargetViewModelOutputProtocol {}

class MyTargetViewModel: MyTargetViewModelProtocol {
    private let disposeBag = DisposeBag()
    var targetSugarRelay = BehaviorRelay<Int>(value: Int())
    
    init() {}
    
    func setCurrentTargetSugar(_ data: Int) {
        UserDefaults.standard.set(data, forKey: UserInfoKey.targetSugar)
    }
    
    func getCurrentTargetSugar() {
        let targetSugar = UserDefaults.standard.integer(forKey: UserInfoKey.targetSugar)
        targetSugarRelay.accept(targetSugar)
    }
}
