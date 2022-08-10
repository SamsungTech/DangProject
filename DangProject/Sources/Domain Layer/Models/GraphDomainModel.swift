//
//  GraphData.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/06.
//

import Foundation

struct GraphDomainModel {
    static let empty: Self = .init(yearArray: [], monthArray: [], dayArray: [])
    var yearArray: [String]
    var monthArray: [String]
    var dayArray: [String]
    
    static var isLatestGraphData: Bool = false
    static func setIsLatestGraphData(_ data: Bool) {
        self.isLatestGraphData = data
    }
    
    init(yearArray: [String],
         monthArray: [String],
         dayArray: [String]) {
        self.yearArray = yearArray
        self.monthArray = monthArray
        self.dayArray = dayArray
    }
    
    init(allGraph: AllGraph) {
        var dummyYearArray: [String] = []
        var dummyMonthArray: [String] = []
        var dummyDayArray: [String] = []
        
        allGraph.graphYearArray.forEach {
            dummyYearArray.append($0.dangAverage ?? "")
        }
        
        allGraph.graphMonthArray.forEach {
            dummyMonthArray.append($0.dangAverage ?? "")
        }
        
        allGraph.graphDayArray.forEach {
            dummyDayArray.append($0.dangAverage ?? "")
        }
        
        self.yearArray = dummyYearArray
        self.monthArray = dummyMonthArray
        self.dayArray = dummyDayArray
    }
}
