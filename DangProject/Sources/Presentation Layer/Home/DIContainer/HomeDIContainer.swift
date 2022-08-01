//
//  HomeDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import UIKit

class HomeDIContainer {
    
    lazy var fetchEatenFoodsUseCase = self.makeFetchEatenFoodsUseCase()
    
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel(),
                                  calendarView: makeCalendarView(),
                                  eatenFoodsView: makeEatenFoodsView(),
                                  batteryView: makeBatteryView())
    }
    
    func makeHomeViewModel() -> HomeViewModelProtocol{
        return HomeViewModel(fetchEatenFoodsUseCase: fetchEatenFoodsUseCase,
                             fetchProfileUseCase: makeFetchProfileUseCase())
    }
    
    func makeCalendarView() -> CalendarView {
        return CalendarView(viewModel: makeCalendarViewModel())
    }
    
    func makeEatenFoodsView() -> EatenFoodsView {
        return EatenFoodsView(viewModel: makeEatenFoodsViewModel())
    }
    
    func makeBatteryView() -> BatteryView {
        return BatteryView(viewModel: makeBatteryViewModel())
    }
    
    func makeCalendarViewModel() -> CalendarViewModel {
        return CalendarViewModel(calendarService: makeCalendarService(),
                                 fetchEatenFoodsUsecase: fetchEatenFoodsUseCase)
    }
    
    func makeCalendarService() -> CalendarService {
        return DefaultCalendarService()
    }
    
    func makeEatenFoodsViewModel() -> EatenFoodsViewModel {
        return EatenFoodsViewModel(fetchEatenFoodsUseCase: fetchEatenFoodsUseCase)
    }
    
    func makeBatteryViewModel() -> BatteryViewModel {
        return BatteryViewModel(fetchEatenFoodsUseCase: fetchEatenFoodsUseCase)
    }
    
    func makeFetchProfileUseCase() -> FetchProfileUseCase {
        return DefaultFetchProfileUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                          firebaseFireStoreUseCase: makeFirebaseFireStoreUseCase(),
                                          manageFirebaseStorageUseCase: makeFirebaseStorageUseCase())
    }
    
    func makeFetchEatenFoodsUseCase() -> FetchEatenFoodsUseCase {
        return DefaultFetchEatenFoodsUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(), firebaseFireStoreUseCase: makeFirebaseFireStoreUseCase())
    }

    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
    
    func makeFirebaseFireStoreUseCase() -> FirebaseFireStoreUseCase {
        return DefaultFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFirebaseStorageUseCase() -> ManageFirebaseStorageUseCase {
        return DefaultManageFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFirebaseStorageManagerRepository())
    }
    
    func makeFirebaseStorageManagerRepository() -> FireBaseStorageManagerRepository {
        return DefaultFirebaseStorageManagerRepository()
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
}
