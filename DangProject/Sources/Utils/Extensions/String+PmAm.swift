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
    
    static func calculatePmAm(_ originTime: Date) -> String {
        dateFormatter.dateFormat = "a"
        return dateFormatter.string(from: originTime)
    }
}
