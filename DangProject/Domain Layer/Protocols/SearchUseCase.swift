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
    func fetchFood(text: String)
    func updateViewModel(keyword: String?)
}
