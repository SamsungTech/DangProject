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
        coreDataManagerRepository.addRecentQuery(keyword)
        queryObservable.onNext(loadQuery())
    }
    
    func loadQuery() -> [String]  {
        var resultQuery: [String] = []
        let savedQuery = coreDataManagerRepository.loadFromCoreData(request: RecentQuery.fetchRequest())
        savedQuery.forEach{ query in
            if let keyWord = query.keyword {
                resultQuery.append(keyWord)
            }
        }
        return resultQuery
    }
    
    func deleteAllQuery() {
        coreDataManagerRepository.deleteAll(request: RecentQuery.fetchRequest())
        queryObservable.onNext(loadQuery())
    }
    
    // MARK: - Private
    func checkQueryWithCoreData(keyword: String) {
        let savedQuery = coreDataManagerRepository.loadFromCoreData(request: RecentQuery.fetchRequest())
        
        savedQuery.forEach{ query in
            if query.keyword == keyword {
                coreDataManagerRepository.deleteQuery(at: query.keyword!, request: RecentQuery.fetchRequest())
            }
        }
    }
}