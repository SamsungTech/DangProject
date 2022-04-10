//
//  CalendarCellViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/01.
//

import Foundation
import RxRelay

struct DaysCellEntity {
    static let empty: Self = .init(yearMonth: "",
                                   days: String(),
                                   isHidden: Bool(),
                                   dang: Double(),
                                   maxDang: Double(),
                                   isCurrentDay: Bool())
    var yearMonth: String
    var days: String
    var isHidden: Bool
    var dang: Double
    var maxDang: Double
    var isCurrentDay: Bool
}

protocol DaysCellViewModelInputProtocol: AnyObject {
    
}

protocol DaysCellViewModelOutputProtocol: AnyObject {
    
}

protocol DaysCellViewModelProtocol: DaysCellViewModelInputProtocol, DaysCellViewModelOutputProtocol {}

class DaysCellViewModel: DaysCellViewModelProtocol {
    var yearMonth = BehaviorRelay<String>(value: "")
    var days = BehaviorRelay<String>(value: "")
    var isHidden = BehaviorRelay<Bool>(value: Bool())
    var circleColor = BehaviorRelay<CGColor>(value: UIColor.clear.cgColor)
    var circleNumber = BehaviorRelay<CGFloat>(value: CGFloat())
    var isCurrentDay = BehaviorRelay<Bool>(value: Bool())
    
    init(calendarData: CalendarStackViewEntity,
         indexPathItem: Int) {
        self.yearMonth.accept(
            calendarData.yearMonth
        )
        self.days.accept(
            calendarData.daysArray[indexPathItem]
        )
        self.isHidden.accept(
            calendarData.isHiddenArray[indexPathItem]
        )
        self.circleColor.accept(
            .calculateColor(
                dang: calendarData.dangArray[indexPathItem],
                maxDang: calendarData.maxDangArray[indexPathItem]
            )
        )
        self.circleNumber.accept(
            .calculateMonthDangDataNumber(
                dang: calendarData.dangArray[indexPathItem],
                maxDang: calendarData.maxDangArray[indexPathItem]
            )
        )
        self.isCurrentDay.accept(
            calendarData.isCurrentDayArray[indexPathItem]
        )
    }
}

extension DaysCellViewModel {
    func calculateAlphaHiddenValues(_ value: Bool,
                                    label: UILabel,
                                    Layer: CAShapeLayer,
                                    backgroundLayer: CAShapeLayer) {
        if value == true {
            label.alpha = 0.2
        } else {
            label.alpha = 1.0
        }
        Layer.isHidden = value
        backgroundLayer.isHidden = value
    }
    
    func calculateCurrentDayAlphaValues(_ value: Bool,
                                        _ view: UIView) {
        if value == false {
            view.isHidden = true
        } else {
            view.isHidden = false
        }
    }
}
