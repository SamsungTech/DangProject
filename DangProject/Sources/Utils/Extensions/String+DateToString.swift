//
//  DateFormatter.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/10.
//

import UIKit

extension String {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter
    }()
    
    static func timeToString(_ time: Date) -> String {
        dateFormatter.dateFormat = "h:mm"
        return dateFormatter.string(from: time)
    }
    
    static func calculateAmPm(_ originTime: Date) -> String {
        dateFormatter.dateFormat = "a"
        return dateFormatter.string(from: originTime)
    }
    
    static func configureWeekOfTheDay(_ num: Int) -> String {
        switch num {
        case 0:
            return "일"
        case 1:
            return "월"
        case 2:
            return "화"
        case 3:
            return "수"
        case 4:
            return "목"
        case 5:
            return "금"
        case 6:
            return "토"
        default:
            return ""
        }
    }
}
