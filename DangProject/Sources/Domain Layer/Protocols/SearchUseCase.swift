//
//  SearchUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/16.
//

import Foundation

import RxSwift

protocol SearchUseCase {
    var foodResultModelObservable: PublishSubject<[FoodViewModel]> { get }
    func fetchFood(text: String, completion: @escaping(Bool)->Void)
    func updateViewModel(keyword: String?)
}
