//
//  SearchFoodUsecase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

import RxSwift

class SearchUseCase {
    let fetchFoodRepository: FetchRepository
    
    init(fetchFoodRepository: FetchRepository) {
        self.fetchFoodRepository = fetchFoodRepository
    }        
    
}
