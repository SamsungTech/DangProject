//
//  CalendarCellViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/01.
//

import Foundation
import RxRelay
import QuartzCore

struct DaysCellEntity {
    static let empty: Self = .init(days: String(),
                                   isHidden: Bool(),
                                   dang: Double(),
                                   maxDang: Double(),
                                   isCurrentDay: Bool())
    var days: String?
    var isHidden: Bool?
    var dang: Double?
    var maxDang: Double?
    var isCurrentDay: Bool?
    
    init(days: String,
         isHidden: Bool,
         dang: Double,
         maxDang: Double,
         isCurrentDay: Bool) {
        self.days = days
        self.isHidden = isHidden
        self.dang = dang
        self.maxDang = maxDang
        self.isCurrentDay = isCurrentDay
    }
}

class DaysCellViewModel {
    var days = BehaviorRelay<String>(value: "")
    var isHidden = BehaviorRelay<Bool>(value: Bool())
    var circleColor = BehaviorRelay<CGColor>(value: UIColor.clear.cgColor)
    var circleNumber = BehaviorRelay<CGFloat>(value: CGFloat())
    var isCurrentDay = BehaviorRelay<Bool>(value: Bool())
    
    init(calendarData: CalendarStackViewEntity,
         indexPathItem: Int) {
        guard let days = calendarData.daysArray?[indexPathItem],
              let isHidden = calendarData.isHiddenArray?[indexPathItem],
              let dang = calendarData.dangArray?[indexPathItem],
              let maxDang = calendarData.maxDangArray?[indexPathItem],
              let isCurrentDay = calendarData.isCurrentDayArray?[indexPathItem] else { return }
        self.days.accept(days)
        self.isHidden.accept(isHidden)
        self.circleColor.accept(calculateColor(dang: dang, maxDang: maxDang))
        self.circleNumber.accept(calculateMonthDangDataNumber(dang: dang, maxDang: maxDang))
        self.isCurrentDay.accept(isCurrentDay)
    }
    
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
    
    private func calculateMonthDangDataNumber(dang: Double,
                                      maxDang: Double) -> CGFloat {
        let dangValueNumber: Double = (dang/maxDang)*Double(80)
        let number3: Double = 80*(dangValueNumber/80)
        let result: Double = number3/100
        
        return CGFloat(result)
    }
    
    private func calculateColor(dang: Double,
                        maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 63 {
            return UIColor.customSmallCircleColor(.smallCircleColorRed).cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.customSmallCircleColor(.smallCircleColorYellow).cgColor
        } else {
            return UIColor.customSmallCircleColor(.smallCircleColorGreen).cgColor
        }
    }
}
