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
    var sixMonthsTotalSugarObservable = PublishSubject<(DateComponents, [TotalSugarPerMonthDomainModel])>()
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
    
    func fetchMonthsData(month dateComponents: DateComponents) {
        let tempMonth = DateComponents.init(year: dateComponents.year!,
                                            month: dateComponents.month!,
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
        if cachedMonth.count == monthIndex + 5 {
            var fiveMonthBefore = dateComponents
            fiveMonthBefore.month = fiveMonthBefore.month! - 5
 
            fetchMonthData(dateComponents: fiveMonthBefore)
                .subscribe(onNext: { [weak self] monthData in
                    self?.cachedMonth.append(fiveMonthBefore)

                })
                .disposed(by: disposeBag)
        }
        
        totalMonthsDataObservable.onNext([
            fetchMonthDataFromCoreData(yearMonth: cachedMonth[monthIndex+1]),
            fetchMonthDataFromCoreData(yearMonth: cachedMonth[monthIndex]),
            fetchMonthDataFromCoreData(yearMonth: cachedMonth[monthIndex-1])
        ])
    }
    
    func fetchCurrentMonthsData() {
        var currentMonth: DateComponents = .currentYearMonth()
        currentMonth.day = 1
                
        lazy var oneMonthBeforeEatenFoodsObservable = PublishSubject<[EatenFoodsPerDayDomainModel]>()
        lazy var currentMonthEatenFoodsObservable = PublishSubject<[EatenFoodsPerDayDomainModel]>()
        lazy var twoMonthBeforeEatenFoodsObservable = PublishSubject<[EatenFoodsPerDayDomainModel]>()
        
        lazy var totalMonthsZipObservable = Observable.zip(oneMonthBeforeEatenFoodsObservable, currentMonthEatenFoodsObservable, twoMonthBeforeEatenFoodsObservable)
        
        for i in 0 ..< 6 {
            fetchMonthData(dateComponents: currentMonth)
                .subscribe(onNext: { monthData in
                    if i == 0 {
                        currentMonthEatenFoodsObservable.onNext(monthData)
                    } else if i == 1 {
                        oneMonthBeforeEatenFoodsObservable.onNext(monthData)
                    } else if i == 2 {
                        twoMonthBeforeEatenFoodsObservable.onNext(monthData)
                    }
                })
                .disposed(by: disposeBag)
            cachedMonth.append(currentMonth)
            currentMonth.month = currentMonth.month! - 1
        }
        
        totalMonthsZipObservable
            .subscribe(onNext: { [weak self] monthData in
                self?.totalMonthsDataObservable.onNext([monthData.0, monthData.1, []])
                self?.emitEatenFoodsObservable(eatenFoods: monthData.1)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchNextMonthData(month: DateComponents) {
        var nextMonth: DateComponents = .currentYearMonth()
        nextMonth.month! = nextMonth.month! + 1
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
    
    private func fetchMonthData(dateComponents: DateComponents) -> Observable<[EatenFoodsPerDayDomainModel]> {
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
                // 1. Remote 호출
                self?.fetchEatenFoodsPerDayFromFireBase(dateComponents: tempDateComponents)
                    .subscribe(onNext: { eatenFoods in
                        // 2. Remote Data 와 Local Data 대조 이후 Remote로 맞춤
                        self?.coreDataManagerRepository.updateLocal(data: eatenFoods, date: .makeDate(year: year, month: month, day: i))
                        
                        // 3. Remote viewModel로 전달
                        eatenFoodsData.append(eatenFoods)
                        if eatenFoodsData.count == dayCounts {
                            emitter.onNext(eatenFoodsData.sorted { $0.date! < $1.date! })
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
    
    func fetchSixMonthsTotalSugar(from dateComponents: DateComponents) {
        guard let year = dateComponents.year,
              let month = dateComponents.month else { return }
        var sixMonthBeforeDateComponents: DateComponents = .init(year: year, month: month-5, day: 1)
        var totalSugarPerSixMonths = [TotalSugarPerMonthDomainModel]()
        for _ in 1...7 {
            let monthData = fetchMonthDataFromCoreData(yearMonth: sixMonthBeforeDateComponents)
            let result = getMonthlyTotalSugar(monthData)
            totalSugarPerSixMonths.append(TotalSugarPerMonthDomainModel.init(month: .configureDateComponents(sixMonthBeforeDateComponents), totalSugarPerMonth: result))
            sixMonthBeforeDateComponents.month = sixMonthBeforeDateComponents.month! + 1
        }
        sixMonthsTotalSugarObservable.onNext((.configureDateComponents(dateComponents), totalSugarPerSixMonths))
    }
    
    // MARK: - Private
    private func fetchEatenFoodsPerDayFromFireBase(dateComponents: DateComponents) -> Observable<EatenFoodsPerDayDomainModel> {
        return Observable.create() { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create()}
            var tempData: EatenFoodsPerDayDomainModel = .empty
            self?.manageFirebaseFireStoreUseCase.getEatenFoods(dateComponents: dateComponents)
                .subscribe(onNext: { eatenFoods in
                    let date: Date = .makeDate(year: dateComponents.year!,
                                               month: dateComponents.month!,
                                               day: dateComponents.day!)
                    let sortedData = eatenFoods.sorted(by: { $0.eatenTime.seconds < $1.eatenTime.seconds })
                    tempData = .init(date: date, eatenFoods: sortedData)
                    emitter.onNext(tempData)
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
    private func emitEatenFoodsObservable(eatenFoods: [EatenFoodsPerDayDomainModel]) {
        let currentIndex = DateComponents.currentDateComponents().day! - 1
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
