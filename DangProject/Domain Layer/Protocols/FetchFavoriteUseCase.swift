//
//  FetchFavoriteUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/16.
//

import Foundation

import RxSwift

protocol FetchFavoriteFoodsUseCase {
    func fetchFavoriteFoods() -> SearchFoodViewModel
}
