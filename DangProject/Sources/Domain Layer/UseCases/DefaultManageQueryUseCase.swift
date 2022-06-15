//
//  AddQueryUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/22.
//
import Foundation

import RxSwift

class DefaultManageQueryUseCase: ManageQueryUseCase {
    
    // MARK: - Init
    let coreDataManagerRepository: CoreDataManagerRepository
    
    init(coreDataManagerRepository: CoreDataManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.updateQuery()
    }
    
    // MARK: - Internal
    var queryObservable = PublishSubject<[String]>()
    
    func updateQuery() {
        queryObservable.onNext(loadQuery())
    }
    
    func addQueryOnCoreData(keyword: String) {
        checkQueryWithCoreData(keyword: keyword)
        coreDataManagerRepository.addRecentQuery(keyword: keyword)
        queryObservable.onNext(loadQuery())
    }
    
    func loadQuery() -> [String]  {
        var resultQuery: [String] = []
        let savedQuery = coreDataManagerRepository.fetchCoreDataArray(from: .recentQuery).map {
            $0 as? RecentQuery ?? RecentQuery.init()
        }
        savedQuery.forEach{ query in
            if let keyWord = query.keyword {
                resultQuery.append(keyWord)
            }
        }
        return resultQuery
    }
    
    func deleteAllQuery() {
        coreDataManagerRepository.deleteAll(coreDataName: .recentQuery)
        queryObservable.onNext(loadQuery())
    }
    
    // MARK: - Private
    func checkQueryWithCoreData(keyword: String) {
        let savedQuery = coreDataManagerRepository.fetchCoreDataArray(from: .recentQuery).map { $0 as? RecentQuery ?? RecentQuery.init() }
        
        savedQuery.forEach{ query in
            if query.keyword == keyword {
                coreDataManagerRepository.deleteQuery(at: query.keyword!)
            }
        }
    }
}
