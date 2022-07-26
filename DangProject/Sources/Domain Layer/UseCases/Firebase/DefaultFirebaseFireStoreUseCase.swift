//
//  FirebaseFireStoreManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import RxSwift
import UIKit
import RxRelay

import FirebaseFirestore

class DefaultFirebaseFireStoreUseCase: FirebaseFireStoreUseCase {
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    private let fireStoreManagerRepository: FireStoreManagerRepository
    var yearMonthDayDataSubject = PublishSubject<GraphData>()
    var yearMonthDayDataRelay = BehaviorRelay<[[String : Any]]>(value: [])
    
    init(fireStoreManagerRepository: FireStoreManagerRepository) {
        self.fireStoreManagerRepository = fireStoreManagerRepository
    }
        
    // MARK: - Internal
    let profileExistenceObservable = PublishSubject<Bool>()
    
    func uploadFirebaseUID(uid: String) {
        fireStoreManagerRepository.saveFirebaseUserDocument(uid: uid, ProfileExistence: false)
    }
    
    func uploadProfile(profile: ProfileDomainModel) {
        fireStoreManagerRepository.saveFirebaseUserDocument(uid: profile.uid, ProfileExistence: true)
        fireStoreManagerRepository.saveProfileDocument(profile: profile)
    }
    
    func getProfileExistence(uid: String) -> Observable<Bool> {
        return Observable.create { [weak self] emitter in
            self?.fireStoreManagerRepository.checkProfileField(with: "profileExistence", uid: uid) {  profileExist in
                if profileExist {
                    emitter.onNext(true)
                } else {
                    emitter.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func getProfileData() -> Observable<ProfileDomainModel> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.fireStoreManagerRepository.getProfileDataInFireStore()
                .subscribe(onNext: { profileData in
                    var domainProfileData = ProfileDomainModel.empty
                    for (key, value) in profileData {
                        switch key {
                        case "name": domainProfileData.name = value as? String ?? ""
                        case "gender": domainProfileData.gender = value as? String ?? ""
                        case "sugarLevel": domainProfileData.sugarLevel = value as? Int ?? 0
                        case "uid": domainProfileData.uid = value as? String ?? ""
                        case "weight": domainProfileData.weight = value as? Int ?? 0
                        case "height": domainProfileData.height = value as? Int ?? 0
                        case "birthDay": domainProfileData.birthDay = value as? String ?? ""
                        default: break
                        }
                    }
                    emitter.onNext(domainProfileData)
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
    func updateProfileData(_ data: ProfileDomainModel) {
        fireStoreManagerRepository.saveProfileDocument(profile: data)
    }
    
    func getEatenFoods(dateComponents: DateComponents) -> Observable<[FoodDomainModel]> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.fireStoreManagerRepository.getEatenFoodsInFirestore(dateComponents: dateComponents)
                .subscribe(onNext: { foodData in
                    var addedFoodDomainModel = [FoodDomainModel]()
                    foodData.forEach { foods in
                        var foodModel = FoodDomainModel.empty
                        for (key, value) in foods {
                            switch key {
                            case "name": foodModel.name = value as? String ?? ""
                            case "sugar": foodModel.sugar = value as? Double ?? 0
                            case "foodCode": foodModel.foodCode = value as? String ?? ""
                            case "amount": foodModel.amount = value as? Int ?? 0
                            case "favorite": foodModel.favorite = value as? Bool ?? false
                            case "eatenTime": foodModel.eatenTime = value as? Timestamp ?? Timestamp.init()
                            default:
                                break
                            }
                        }
                        addedFoodDomainModel.append(foodModel)
                    }
                    emitter.onNext(addedFoodDomainModel)
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
        
    }
    
    func uploadEatenFood(eatenFood: FoodDomainModel) {
        fireStoreManagerRepository.saveEatenFood(eatenFood: eatenFood)
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
                    GraphData(yearArray: yearArray,
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
