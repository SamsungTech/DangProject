//
//  AddQueryUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/22.
//

import Foundation

class ManageQueryUseCase {
    
    let coreDataManagerRepository: CoreDataManagerRepository
    
    init(coreDataManagerRepository: CoreDataManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
    }
    
    func addQueryOnCoreData(keyword: String, completion: @escaping ()-> Void) {
        checkQueryWithCoreData(keyword: keyword)
        coreDataManagerRepository.addRecentQuery(keyword)
        completion()
    }
    
    func checkQueryWithCoreData(keyword: String) {
        let savedQuery = coreDataManagerRepository.loadFromCoreData(request: RecentQuery.fetchRequest())
        
        savedQuery.forEach{ query in
            if query.keyword == keyword {
                coreDataManagerRepository.deleteQuery(at: query.keyword!, request: RecentQuery.fetchRequest())
            }
        }
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
    }
}
