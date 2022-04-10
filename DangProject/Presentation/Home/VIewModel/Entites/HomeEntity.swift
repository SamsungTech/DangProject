//
//  HomeEntity.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/08.
//

import UIKit

enum PagingState {
    case left
    case right(Int)
    case empty
}

enum ScrollDirection {
    case right
    case center
    case left
}

enum CalendarScaleState {
    case expand
    case revert
}

struct SelectedCellEntity: Equatable {
    static let empty: Self = .init(selectedCircleColor: UIColor.clear.cgColor,
                                   selectedCircleBackgroundColor: UIColor.clear.cgColor,
                                   selectedDangValue: "",
                                   selectedMaxDangValue: "",
                                   circleDangValue: 0,
                                   circlePercentValue: 0,
                                   circleAnimationDuration: 0.0,
                                   selectedAnimationLineColor: UIColor.clear.cgColor)
    var selectedCircleColor: CGColor
    var selectedCircleBackgroundColor: CGColor
    var selectedDangValue: String
    var selectedMaxDangValue: String
    var circleDangValue: CGFloat
    var circlePercentValue: Int
    var circleAnimationDuration: Double
    var selectedAnimationLineColor: CGColor
}


struct DangComprehensive: Equatable {
    static let empty: Self = .init(yearMonthWeekDang: .empty)
    var tempDang: [String]?
    var tempFoodName: [String]?
    var weekDang: [String]?
    var monthDang: [Double]?
    var monthMaxDang: [Double]?
    var yearDang: [String]?
    var todaySugarSum: String?
}

extension DangComprehensive {
    init(yearMonthWeekDang: YearMonthWeekDang) {
        self.tempDang = yearMonthWeekDang.tempDang
        self.tempFoodName = yearMonthWeekDang.tempFoodName
        self.weekDang = yearMonthWeekDang.weekDang
        self.monthDang = yearMonthWeekDang.monthDang
        self.monthMaxDang = yearMonthWeekDang.monthMaxDang
        self.yearDang = yearMonthWeekDang.yearDang
        self.todaySugarSum = doubleToString(double: yearMonthWeekDang.todaySugarSum ?? 0.0)
    }
    
    private func doubleToString(double: Double) -> String {
        return String(double)
    }
    
    private func doubleArrayToStringArray(doubleArray: [Double]) -> [String] {
        var resultArray: [String] = []
        
        for d in doubleArray {
            let result = String(d)
            resultArray.append(result)
        }
        
        return resultArray
    }
}
