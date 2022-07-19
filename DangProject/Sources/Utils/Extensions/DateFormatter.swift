//
//  DateFormatter.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/19.
//

import Foundation

extension DateFormatter {
    static func formatDate() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter
    }
}
