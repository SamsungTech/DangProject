//
//  SearchUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/16.
//

import Foundation

import RxSwift

protocol SearchUseCase {
    var foodResultModelObservable: PublishSubject<SearchFoodViewModel> { get }
    func fetchFood(text: String)
    func updateViewModel()
}
