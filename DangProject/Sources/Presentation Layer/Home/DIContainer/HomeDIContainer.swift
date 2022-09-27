//
//  HomeDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import UIKit

class HomeDIContainer {
    
    lazy var fetchEatenFoodsUseCase = self.makeFetchEatenFoodsUseCase()
    lazy var profileManagerUseCase = self.makeProfileManagerUseCase()
    
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel(),
                                  calendarView: makeCalendarView(),
                                  eatenFoodsView: makeEatenFoodsView(),
                                  batteryView: makeBatteryView(),
                                  graphView: makeGraphView())
    }
    
    func makeHomeViewModel() -> HomeViewModelProtocol{
        return HomeViewModel(fetchEatenFoodsUseCase: fetchEatenFoodsUseCase,
                             profileManagerUseCase: profileManagerUseCase)
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
    
    func makeGraphView() -> GraphView {
        return GraphView(viewModel: makeGraphViewModel())
    }
    
    func makeCalendarViewModel() -> CalendarViewModel {
        return CalendarViewModel(calendarService: makeCalendarService(),
                                 fetchEatenFoodsUseCase: fetchEatenFoodsUseCase,
                                 profileManagerUseCase: profileManagerUseCase)
    }
    
    func makeGraphViewModel() -> GraphViewModelProtocol {
        return GraphViewModel(fetchEatenFoodsUseCase: fetchEatenFoodsUseCase)
    }
    
    func makeCalendarService() -> CalendarService {
        return DefaultCalendarService()
    }
    
    func makeEatenFoodsViewModel() -> EatenFoodsViewModel {
        return EatenFoodsViewModel(fetchEatenFoodsUseCase: fetchEatenFoodsUseCase,
                                   profileManagerUseCase: profileManagerUseCase)
    }
    
    func makeBatteryViewModel() -> BatteryViewModel {
        return BatteryViewModel(fetchEatenFoodsUseCase: fetchEatenFoodsUseCase,
                                profileManagerUseCase: profileManagerUseCase)
    }
    
    func makeProfileManagerUseCase() -> ProfileManagerUseCase {
        return DefaultProfileManagerUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                          manageFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase(),
                                          manageFirebaseStorageUseCase: makeManageFirebaseStorageUseCase())
    }
    
    func makeFetchEatenFoodsUseCase() -> FetchEatenFoodsUseCase {
        return DefaultFetchEatenFoodsUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                             manageFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase())
    }

    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
    
    func makeManageFirebaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeManageFirebaseStorageUseCase() -> ManageFirebaseStorageUseCase {
        return DefaultManageFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFirebaseStorageManagerRepository())
    }
    
    func makeFirebaseStorageManagerRepository() -> FireBaseStorageManagerRepository {
        return DefaultFirebaseStorageManagerRepository()
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
}
