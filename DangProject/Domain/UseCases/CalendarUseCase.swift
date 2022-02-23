//
//  CalendarUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/20.
//

import Foundation
import UIKit
import RxSwift

// MARK: 그럼 각기 다른 repository를 가질수 있나? useCase마다 다른 repository
// MARK: 사용되는 객체 = days(몇개의 cell이 필요한지), weeks
class CalendarUseCase {
    let currentDate = Date()
    var calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var dateComponents = DateComponents()
    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var days: [String] = []
    var daysCount = 0
    var startDay = 0
    var yearMonth = ""
    
    func calculationDaysInMouth() -> Observable<CalendarEntity> {
        dateFormatter.dateFormat = "yyyy년 M월"
        dateComponents.year = calendar.component(.year, from: currentDate)
        dateComponents.month = calendar.component(.month, from: currentDate)
        dateComponents.day = 1
        
        if let firstDay = calendar.date(from: dateComponents) {
            let firstWeekDay = calendar.component(.weekday, from: firstDay)
            
            daysCount = calendar.range(of: .day, in: .month, for: firstDay)?.count ?? 0
            startDay = 2 - firstWeekDay
            yearMonth = dateFormatter.string(from: firstDay)
        }
        
        self.days.removeAll()
        for day in startDay...daysCount {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
        
        return Observable.create { [weak self] (observer) -> Disposable in
            observer.onNext(
                CalendarEntity(days: self?.days,
                               daysCount: self?.daysCount,
                               weeks: self?.weeks,
                               yearMouth: self?.yearMonth)
            )
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
