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
    // MARK: - Init
    private let coreDataManagerRepository: CoreDataManagerRepository
    private let firebaseFireStoreUseCase: FirebaseFireStoreUseCase
    init(coreDataManagerRepository: CoreDataManagerRepository,
         firebaseFireStoreUseCase: FirebaseFireStoreUseCase) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.firebaseFireStoreUseCase = firebaseFireStoreUseCase
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
        
        if cachedMonth.contains(currentMonth) {
            totalMonthsDataObservable.onNext([
                fetchMonthDataFromCoreData(yearMonth: cachedMonth[1]),
                fetchMonthDataFromCoreData(yearMonth: cachedMonth[0]),
                []
            ])
            return
        }
        
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
            })
            .disposed(by: disposeBag)
        
        cachedMonth = [currentMonth, oneMonthBefore, twoMonthBefore]
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
        let eatenFoods = coreDataManagerRepository.fetchEatenFoodsPerDay(date: date)
        eatenFoodsObservable.onNext(EatenFoodsPerDayDomainModel.init(eatenFoods))
    }
    
    // MARK: - Private
    private func makeEatenFoodsPerDayModelFromFireBase(dateComponents: DateComponents) -> EatenFoodsPerDayDomainModel {
        var tempData: EatenFoodsPerDayDomainModel = .empty
        firebaseFireStoreUseCase.getEatenFoods(dateComponents: dateComponents)
            .subscribe(onNext: { eatenFoods in
                let date: Date = .makeDate(year: dateComponents.year!,
                                           month: dateComponents.month!,
                                           day: dateComponents.day!)
                tempData = .init(date: date, eatenFoods: eatenFoods)
            })
            .disposed(by: disposeBag)
        return tempData
    }
    
    private func fetchEatenFoodsPerDayFromFireBase(dateComponents: DateComponents) -> Observable<EatenFoodsPerDayDomainModel> {
        return Observable.create() { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create()}
            var tempData: EatenFoodsPerDayDomainModel = .empty
            self?.firebaseFireStoreUseCase.getEatenFoods(dateComponents: dateComponents)
                .subscribe(onNext: { eatenFoods in
                    let date: Date = .makeDate(year: dateComponents.year!,
                                               month: dateComponents.month!,
                                               day: dateComponents.day!)
                    tempData = .init(date: date, eatenFoods: eatenFoods)
                    emitter.onNext(tempData)
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
}
