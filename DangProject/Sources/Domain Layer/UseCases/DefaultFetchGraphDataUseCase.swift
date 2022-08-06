//
//  DefaultFetchGraphDataUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/08/06.
//

import Foundation

import RxSwift
import RxRelay

class DefaultFetchGraphDataUseCase: FetchGraphDataUseCase {
    private let fireStoreManagerRepository: FireStoreManagerRepository
    private let disposeBag = DisposeBag()
    
    
    var yearMonthDayDataSubject = PublishSubject<GraphDomainModel>()
    var yearMonthDayDataRelay = BehaviorRelay<[[String : Any]]>(value: [])
    
    
    
    init(fireStoreManagerRepository: FireStoreManagerRepository) {
        self.fireStoreManagerRepository = fireStoreManagerRepository
    }
    
    func createGraphThisYearMonthDayData() {
        var yearArray: [String] = []
        var monthArray: [String] = []
        var daysArray: [String] = []
        var yearMonthDaysArray: [[String:Any]] = []
        
        let yearData = self.fireStoreManagerRepository.getGraphAllYearDataInFireStore()
        let monthData = self.fireStoreManagerRepository.getGraphAllThisMonthDataInFireStore()
        let dayData = self.fireStoreManagerRepository.getGraphAllThisDaysDataInFireStore()
        
        Observable.combineLatest(yearData, monthData, dayData)
            .subscribe(onNext: { [weak self] yearMonthDayData in
                guard let strongSelf = self else { return }
                yearMonthDayData.0.forEach { yearData in
                    let year = strongSelf.createGraphArray(yearData, "year")
                    yearArray = year
                    yearMonthDaysArray.append(yearData)
                }
                yearMonthDayData.1.forEach { monthData in
                    let month = strongSelf.createGraphArray(monthData, "month")
                    monthArray = month
                    yearMonthDaysArray.append(monthData)

                }
                yearMonthDayData.2.forEach { dayData in
                    let day = strongSelf.createGraphArray(dayData, "day")
                    daysArray = day
                    yearMonthDaysArray.append(dayData)
                }
                self?.yearMonthDayDataSubject.onNext(
                    GraphDomainModel(yearArray: yearArray,
                                     monthArray: monthArray,
                                     dayArray: daysArray)
                )
                
                self?.yearMonthDayDataRelay.accept(yearMonthDaysArray)
            })
            .disposed(by: disposeBag)
    }
    
    func uploadDangAverage(_ data: Int) {
        let today = DateComponents.currentDateTimeComponents()
        guard let year = today.year,
              let month = today.month,
              let day = today.day else { return }
        let yearMonthDayValue = yearMonthDayDataRelay.value
        
        // MARK: days
        let uploadDayValue = calculateCalendarDictionary(yearMonthDayValue[2], day, data)
        self.fireStoreManagerRepository.setGraphDaysDataInFireStore(uploadDayValue)
        
        // MARK: month
        let monthAverageData = calculateCalendarAverage(yearMonthDayValue[2])
        let uploadMonthValue = calculateCalendarDictionary(yearMonthDayValue[1], month, monthAverageData)
        self.fireStoreManagerRepository.setGraphMonthDataInFireStore(uploadMonthValue)
        
        // MARK: year
        let yearAverageData = calculateCalendarAverage(yearMonthDayValue[1])
        let uploadYearValue = calculateCalendarDictionary(yearMonthDayValue[0], year, yearAverageData)
        self.fireStoreManagerRepository.setGraphYearDataInFireStore(uploadYearValue)
    }
    
    private func calculateCalendarAverage(_ dictionaryValue: [String:Any]) -> Int {
        var dangTotal = 0
        let dataCount = dictionaryValue.count
        
        for (_, value) in dictionaryValue {
            if let value = value as? String {
                dangTotal+=Int(value)!
            }
        }
        
        let result = dangTotal/dataCount
        
        return result
    }
    
    private func calculateCalendarDictionary(_ data: [String:Any],
                                             _ date: Int,
                                             _ uploadValue: Int) -> [String:Any] {
        var dateData: [String:Any] = [:]
        var dateExistence: Bool = false
        
        data.forEach { (key, value) in
            if key == String(date) {
                guard let value = value as? Int else { return }
                dateData.updateValue(String(value+uploadValue), forKey: key)
                dateExistence = true
            } else {
                dateData.updateValue(value, forKey: key)
            }
        }
        
        if dateExistence == false {
            dateData.updateValue(String(uploadValue), forKey: String(date))
        }
        
        return dateData
    }
    
    private func createGraphArray(_ data: [String:Any],
                                  _ type: String) -> [String] {
        let thisData = createThisData(type)
        var yearArray: [String] = []
        var array: [String] = []
        
        for i in 0...6 {
            let result = thisData - i
            yearArray.append(String(result))
        }
        for j in yearArray {
            data.forEach { (key, value) in
                if j == key {
                    guard let value = value as? String else { return }
                    array.append(value)
                }
            }
        }
        
        if array.count != 7 {
            for _ in 0..<7-array.count {
                array.append("0")
            }
        }
        array = array.reversed()
        return array
    }
    
    private func createThisData(_ type: String) -> Int {
        let today = DateComponents.currentDateTimeComponents()
        switch type {
        case "year":
            return today.year ?? 0
        case "month":
            return today.month ?? 0
        case "day":
            return today.day ?? 0
        default:
            return 0
        }
    }
}
