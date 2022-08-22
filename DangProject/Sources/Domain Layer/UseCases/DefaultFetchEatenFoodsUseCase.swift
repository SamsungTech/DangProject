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
    private let twoMonthBeforeEatenFoodsObservable = PublishSubject<[EatenFoodsPerDayDomainModel]>()
    
    let totalMonthsDataObservable = PublishSubject<[[EatenFoodsPerDayDomainModel]]>()
    
    var cachedMonth: [DateComponents] = []
    
    let eatenFoodsObservable = PublishSubject<EatenFoodsPerDayDomainModel>()
    var monthlyTotalSugarObservable = PublishSubject<[TotalSugarPerMonthDomainModel]>()
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
        if cachedMonth.count == monthIndex + 2 {
            var twoMonthBefore = dateComponents
            twoMonthBefore.month = twoMonthBefore.month! - 2
 
            fetchMonthData(dateComponents: twoMonthBefore)
                .subscribe(onNext: { [weak self] monthData in
                    self?.cachedMonth.append(twoMonthBefore)

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
                
        let oneMonthBeforeEatenFoodsObservable = PublishSubject<[EatenFoodsPerDayDomainModel]>()
        let currentMonthEatenFoodsObservable = PublishSubject<[EatenFoodsPerDayDomainModel]>()
        lazy var totalMonthsZipObservable = Observable.zip(oneMonthBeforeEatenFoodsObservable, currentMonthEatenFoodsObservable, twoMonthBeforeEatenFoodsObservable)
        
        var oneMonthBefore = currentMonth
        oneMonthBefore.month = oneMonthBefore.month! - 1
        var twoMonthBefore = currentMonth
        twoMonthBefore.month = twoMonthBefore.month! - 2
        
        fetchMonthData(dateComponents: twoMonthBefore)
            .subscribe(onNext: { [weak self] monthData in
                self?.twoMonthBeforeEatenFoodsObservable.onNext(monthData)
            })
            .disposed(by: disposeBag)
        
        fetchMonthData(dateComponents: oneMonthBefore)
            .subscribe(onNext: { monthData in
                oneMonthBeforeEatenFoodsObservable.onNext(monthData)
            })
            .disposed(by: disposeBag)
        
        fetchMonthData(dateComponents: currentMonth)
            .subscribe(onNext: { monthData in
                currentMonthEatenFoodsObservable.onNext(monthData)
            })
            .disposed(by: disposeBag)
        
        totalMonthsZipObservable
            .subscribe(onNext: { [weak self] monthData in
                self?.totalMonthsDataObservable.onNext([monthData.0, monthData.1, []])
                self?.emitEatenFoodsObservable(eatenFoods: monthData.1)
            })
            .disposed(by: disposeBag)
        
        cachedMonth = [currentMonth, oneMonthBefore, twoMonthBefore]
        
        // test
        fetchMonthlyTotalSugar(.currentYearMonth())
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
    
    func fetchMonthlyTotalSugar(_ dateComponents: DateComponents) {
        guard let year = dateComponents.year,
              let month = dateComponents.month else { return }
        var firstDay: DateComponents = .init(year: year, month: 1, day: 1)
        var totalSugarPerMonth = [TotalSugarPerMonthDomainModel]()
        
        for i in 1...month {
            fetchMonthData(dateComponents: firstDay)
                .subscribe(onNext: { [weak self] monthData in
                    guard let result = self?.getMonthlyTotalSugar(monthData) else { return }
                    totalSugarPerMonth.append(TotalSugarPerMonthDomainModel.init(month: i, totalSugarPerMonth: result))
                    
                    if totalSugarPerMonth.count == month {
                        let sortedResult = totalSugarPerMonth.sorted {
                            $0.month < $1.month
                        }
                        self?.monthlyTotalSugarObservable.onNext(sortedResult)
                        
                        // test
                        sortedResult.forEach {
                            print($0.month, $0.totalSugarPerMonth)
                        }
                        
                    }
                })
                .disposed(by: disposeBag)
            firstDay.month = firstDay.month! + 1
        }
        
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
