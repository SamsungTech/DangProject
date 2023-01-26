//
//  FetchEatenFoodsUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/15.
//

import Foundation

import RxSwift

class DefaultFetchEatenFoodsUseCase: FetchEatenFoodsUseCase {
    private let disposeBag = DisposeBag()
    let totalMonthsDataObservable = PublishSubject<[[EatenFoodsPerDayDomainModel]]>()
    let eatenFoodsObservable = PublishSubject<EatenFoodsPerDayDomainModel>()
    var sevenMonthsTotalSugarObservable = PublishSubject<(DateComponents, [TotalSugarPerMonthDomainModel])>()
    var cachedMonth: [DateComponents] = []
    // MARK: - Init
    private let coreDataManagerRepository: CoreDataManagerRepository
    private let manageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase
    
    init(coreDataManagerRepository: CoreDataManagerRepository,
         manageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.manageFirebaseFireStoreUseCase = manageFirebaseFireStoreUseCase
    }
    
    // MARK: - Internal
    
    func fetchMonthsData(month dateComponents: DateComponents,
                         completion: @escaping(Bool)->Void) {
        guard let year = dateComponents.year,
              let month = dateComponents.month else { return }
        let tempMonth = DateComponents.init(year: year,
                                            month: month,
                                            day: 1)
        guard let monthIndex = cachedMonth.firstIndex(of: tempMonth) else {
            return
        }
        if monthIndex == 0 {
            return totalMonthsDataObservable.onNext([
                fetchMonthDataFromCoreData(yearMonth: cachedMonth[monthIndex+1]),
                fetchMonthDataFromCoreData(yearMonth: cachedMonth[monthIndex]),
                []
            ])
        }
        if cachedMonth.count == monthIndex + 6 {
            var sixMonthBefore = dateComponents
            guard let sixMonth = sixMonthBefore.month else { return }
            sixMonthBefore.month = sixMonth - 6
            fetchMonthData(dateComponents: sixMonthBefore)
                .subscribe(onNext: { [weak self] monthData, bool in
                    if bool {
                        self?.cachedMonth.append(sixMonthBefore)
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
                .disposed(by: disposeBag)
        }
        
        totalMonthsDataObservable.onNext([
            fetchMonthDataFromCoreData(yearMonth: cachedMonth[monthIndex+1]),
            fetchMonthDataFromCoreData(yearMonth: cachedMonth[monthIndex]),
            fetchMonthDataFromCoreData(yearMonth: cachedMonth[monthIndex-1])
        ])
    }
    
    func fetchCurrentMonthsData(completion: @escaping(Bool)->Void) {
        var currentMonth: DateComponents = .currentYearMonth()
        currentMonth.day = 1
                
        lazy var oneMonthBeforeEatenFoodsObservable = PublishSubject<[EatenFoodsPerDayDomainModel]>()
        lazy var currentMonthEatenFoodsObservable = PublishSubject<[EatenFoodsPerDayDomainModel]>()
        lazy var twoMonthBeforeEatenFoodsObservable = PublishSubject<[EatenFoodsPerDayDomainModel]>()
        
        lazy var totalMonthsZipObservable = Observable.zip(oneMonthBeforeEatenFoodsObservable, currentMonthEatenFoodsObservable, twoMonthBeforeEatenFoodsObservable)
        
        for i in 0 ..< 7 {
            fetchMonthData(dateComponents: currentMonth)
                .subscribe(onNext: { monthData, bool in
                    if bool {
                        if i == 0 {
                            currentMonthEatenFoodsObservable.onNext(monthData)
                        } else if i == 1 {
                            oneMonthBeforeEatenFoodsObservable.onNext(monthData)
                        } else if i == 2 {
                            twoMonthBeforeEatenFoodsObservable.onNext(monthData)
                        }
                    } else {
                        completion(false)
                    }
                })
                .disposed(by: disposeBag)
            cachedMonth.append(currentMonth)
            
            guard let month = currentMonth.month,
                  let year = currentMonth.year else { return }
            
            if month-1 == 0 {
                currentMonth.year = year - 1
                currentMonth.month = 12
            } else {
                currentMonth.month = month - 1
            }
        }
        
        totalMonthsZipObservable
            .subscribe(onNext: { [weak self] monthData in
                self?.totalMonthsDataObservable.onNext([monthData.0, monthData.1, []])
                self?.emitEatenFoodsObservable(eatenFoods: monthData.1)
                self?.fetchSevenMonthsTotalSugar(from: .currentDateComponents())
                completion(true)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchNextMonthData(month: DateComponents) {
        var nextMonth: DateComponents = .currentYearMonth()
        guard var nextMonthResult = nextMonth.month else { return }
        
        nextMonth.month = nextMonthResult + 1
        nextMonth.day = 1
        if month == nextMonth {
            totalMonthsDataObservable.onNext([
                fetchMonthDataFromCoreData(yearMonth: cachedMonth[0]),
                [],[]
            ])
        } else {
            totalMonthsDataObservable.onNext([[], [], []])
        }
    }
    
    private func fetchMonthDataFromCoreData(yearMonth: DateComponents) -> [EatenFoodsPerDayDomainModel] {
        guard let year = yearMonth.year,
              let month = yearMonth.month else {
            return []
        }
        let dayCounts: Int = .calculateDaysCount(year: year, month: month)
        var eatenFoodsData: [EatenFoodsPerDayDomainModel] = []
        
        for i in 1 ... dayCounts {
            let tempDate: Date = .makeDate(year: year,
                                           month: month,
                                           day: i)
            let result = coreDataManagerRepository.fetchEatenFoodsPerDay(date: tempDate)
            eatenFoodsData.append(EatenFoodsPerDayDomainModel.init(result))
        }
        return eatenFoodsData
    }
    
    private func fetchMonthData(dateComponents: DateComponents) -> Observable<([EatenFoodsPerDayDomainModel], Bool)> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self,
                  let year = dateComponents.year,
                  let month = dateComponents.month else {
                return Disposables.create()
            }
            let dayCounts: Int = .calculateDaysCount(year: year, month: month)
            var eatenFoodsData: [EatenFoodsPerDayDomainModel] = []
            
            for i in 1 ... dayCounts {
                let tempDateComponents: DateComponents = .init(year: year,
                                                               month: month,
                                                               day: i)
                let tempDate = Date.dateComponentsToDate(tempDateComponents)
                // 1. Remote 호출
                self?.fetchEatenFoodsPerDayFromFireBase(dateComponents: tempDateComponents)
                    .subscribe(onNext: { eatenFoods, bool in
                        // 2. Remote Data 와 Local Data 대조 이후 Remote로 맞춤
                        if bool {
                            self?.coreDataManagerRepository.updateLocal(data: eatenFoods, date: .makeDate(year: year, month: month, day: i))
                            
                            // 3. Remote viewModel로 전달
                            eatenFoodsData.append(eatenFoods)
                            if eatenFoodsData.count == dayCounts {
                                emitter.onNext((eatenFoodsData.sorted { $0.date ?? tempDate < $1.date ?? tempDate }, true))
                            }
                        } else {
                            emitter.onNext(([], false))
                        }
                    })
                    .disposed(by: strongSelf.disposeBag)
            }
            return Disposables.create()
        }
    }
        
    func fetchEatenFoods(date: Date = Date.currentDate()) {
        coreDataManagerRepository.checkEatenFoodsPerDay(date: date)
            .subscribe(onNext: { [weak self] isFirst, eatenFoods in
                if isFirst {
                    self?.eatenFoodsObservable.onNext(EatenFoodsPerDayDomainModel.init(date: date, eatenFoods: []))
                } else {
                    self?.eatenFoodsObservable.onNext(EatenFoodsPerDayDomainModel.init(eatenFoods))
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchSevenMonthsTotalSugar(from dateComponents: DateComponents) {
        guard let year = dateComponents.year,
              let month = dateComponents.month else { return }
        var sixMonthBeforeDateComponents: DateComponents = .init(year: year, month: month - 6, day: 1)
        var totalSugarPerSixMonths = [TotalSugarPerMonthDomainModel]()
        
        
        for _ in 0 ..< 8 {
            guard var sixMonth = sixMonthBeforeDateComponents.month else { return }
            
            let monthData = fetchMonthDataFromCoreData(yearMonth: sixMonthBeforeDateComponents)
            let result = getMonthlyTotalSugar(monthData)
            totalSugarPerSixMonths.append(TotalSugarPerMonthDomainModel.init(month: .configureDateComponents(sixMonthBeforeDateComponents), totalSugarPerMonth: result))
            
            sixMonthBeforeDateComponents.month = sixMonth + 1
        }
        sevenMonthsTotalSugarObservable.onNext((.configureDateComponents(dateComponents), totalSugarPerSixMonths))
    }
    
    // MARK: - Private
    private func fetchEatenFoodsPerDayFromFireBase(dateComponents: DateComponents) -> Observable<(EatenFoodsPerDayDomainModel, Bool)> {
        return Observable.create() { [weak self] emitter in
            guard let strongSelf = self,
                  let year = dateComponents.year,
                  let month = dateComponents.month,
                  let day = dateComponents.day else { return Disposables.create()}
            var tempData: EatenFoodsPerDayDomainModel = .empty
            self?.manageFirebaseFireStoreUseCase.getEatenFoods(dateComponents: dateComponents)
                .subscribe(onNext: { eatenFoods, bool in
                    if bool {
                        let date: Date = .makeDate(year: year,
                                                   month: month,
                                                   day: day)
                        let sortedData = eatenFoods.sorted(by: { $0.eatenTime.seconds < $1.eatenTime.seconds })
                        tempData = .init(date: date, eatenFoods: sortedData)
                        emitter.onNext((tempData, true))
                    } else {
                        emitter.onNext((EatenFoodsPerDayDomainModel.empty, false))
                    }
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
    private func emitEatenFoodsObservable(eatenFoods: [EatenFoodsPerDayDomainModel]) {
        guard let currentDay = DateComponents.currentDateComponents().day else { return }
        let currentIndex = currentDay - 1
        eatenFoodsObservable.onNext(eatenFoods[currentIndex])
    }
    
    private func getMonthlyTotalSugar(_ monthData: [EatenFoodsPerDayDomainModel]) -> [TotalSugarPerDayDomainModel] {
        var result = [TotalSugarPerDayDomainModel]()
        monthData.forEach { eatenFoodsPerDay in
            var totalSugar: Double = 0
            eatenFoodsPerDay.eatenFoods.forEach { eatenFoods in
                totalSugar = totalSugar + (Double(eatenFoods.amount) * eatenFoods.sugar)
            }
            result.append(TotalSugarPerDayDomainModel.init(date: eatenFoodsPerDay.date ?? Date.init(),
                                                           totalSugar: totalSugar))
        }
        return result
    }
}
