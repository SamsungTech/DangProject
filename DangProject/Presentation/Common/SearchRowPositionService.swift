//
//  SearchRowPositionService.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/06.
//

import UIKit

final class SearchRowPositionService {
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    func calculateRowPoint(_ alarmData: AlarmEntity,
                           _ alarmArray: [AlarmEntity]) -> IndexPath {
        guard let alarmTime = dateFormatter.date(from: alarmData.time) else { return IndexPath() }
        var resultValue = IndexPath(row: 0, section: 0)
        
        if alarmArray.isEmpty == true {
            resultValue = IndexPath(row: 0, section: 0)
        } else {
            let count = compareTimeData(alarmTime, alarmArray)
            resultValue = IndexPath(row: count, section: 0)
        }
        
        return resultValue
    }
    
    private func compareTimeData(_ alarmTime: Date,
                                 _ alarmArray: [AlarmEntity]) -> Int {
        var count = 0
        
        alarmArray.forEach {
            guard let data = dateFormatter.date(from: $0.time) else { return }

            let data3 = alarmTime.compare(data)
            switch data3 {
            case .orderedAscending:
                break
            case .orderedSame:
                count += 1
                break
            case .orderedDescending:
                count += 1
            }
        }
        
        return count
    }
}

