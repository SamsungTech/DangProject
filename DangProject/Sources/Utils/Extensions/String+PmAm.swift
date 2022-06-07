//
//  DateFormatter.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/10.
//

import UIKit

extension String {
    static func calculatePmAm(_ time: String) -> String {
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter
        }()
        
        guard let time = dateFormatter.date(from: time) else { return "" }
        let value = "12:00"
        guard let compareValue = dateFormatter.date(from: value) else { return "" }
        
        let result = compareValue.compare(time)
        switch result {
        case .orderedAscending:
            return "오후"
        case .orderedSame:
            return "오후"
        case .orderedDescending:
            return "오전"
        default:
            return ""
        }
    }
    
    static func calculateTime(_ time: String) -> String {
        
        if String.calculatePmAm(time) == "오후" {
            let time1 = time.components(separatedBy: [":"]).joined()
            let time2 = String(time1)
            guard let timeToInt = Int(time2) else { return "" }
            
            var result = String(timeToInt-1200)
            let final = result.index(result.startIndex, offsetBy: 1)
            result.insert(":", at: final)
            return result
        } else {
            return time
        }
    }
}
