//
//  HomeUseCaseProtocol.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/06.
//

import Foundation

import RxSwift
import RxRelay

protocol HomeUseCaseInputProtocol {
    var yearMonthWeekDangData: BehaviorRelay<YearMonthWeekDang> { get }
}

protocol HomeUseCaseOutputProtocol {
    func execute()
}

protocol HomeUseCaseProtocol: HomeUseCaseOutputProtocol, HomeUseCaseInputProtocol {}
