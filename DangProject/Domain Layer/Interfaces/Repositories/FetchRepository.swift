//
//  FetchFoodRepository.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

import RxSwift

protocol FetchRepository {
    
    var foodDomainModelObservable: PublishSubject<[FoodDomainModel]> { get }
    
    func fetchToDomainModel(text: String)
    
}
