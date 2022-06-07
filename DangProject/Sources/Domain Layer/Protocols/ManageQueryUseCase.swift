//
//  ManageQueryUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/16.
//

import Foundation

import RxSwift

protocol ManageQueryUseCase {
    var queryObservable: PublishSubject<[String]> { get }
    func updateQuery()
    func addQueryOnCoreData(keyword: String)
    func loadQuery() -> [String]
    func deleteAllQuery()
}
