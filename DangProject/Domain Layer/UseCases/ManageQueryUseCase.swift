//
//  AddQueryUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/22.
//

import Foundation

class ManageQueryUseCase {
    func addQueryOnCoreData(keyword: String, completion: @escaping ()-> Void) {
        checkQueryWithCoreData(keyword: keyword)
        CoreDataManager.shared.addRecentQuery(keyword)
        completion()
    }
    
    func checkQueryWithCoreData(keyword: String) {
        let savedQuery = CoreDataManager.shared.loadFromCoreData(request: RecentQuery.fetchRequest())
        
        savedQuery.forEach{ query in
            if query.keyWord == keyword {
                CoreDataManager.shared.deleteQuery(at: query.keyWord!, request: RecentQuery.fetchRequest())
            }
        }
    }
    
    func loadQuery() -> [String]  {
        var resultQuery: [String] = []
        let savedQuery = CoreDataManager.shared.loadFromCoreData(request: RecentQuery.fetchRequest())
        savedQuery.forEach{ query in
            resultQuery.append(query.keyWord!)
        }
        return resultQuery
    }
    
    func deleteAllQuery() {
        CoreDataManager.shared.deleteAll(request: RecentQuery.fetchRequest())
    }
}
