//
//  FetchFoodRepository.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation
import RxSwift

protocol FetchRepository {
    func fetchFoodRx(text: String) -> Observable<Data>
}
