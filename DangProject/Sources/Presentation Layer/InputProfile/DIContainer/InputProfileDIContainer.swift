import UIKit

class InputProfileDIContainer {
    
    func makeInputProfileViewController() -> InputProfileViewController {
        return InputProfileViewController(viewModel: makeInputProfileViewModel())
    }
    
    func makeInputProfileViewModel() -> InputProfileViewModel {
        return InputProfileViewModel(profileManageUseCase: makeProfileManagerUseCase(),
                                     manageFirebaseStorageUseCase: makeFirebaseStorageUseCase())
    }
    
    func makeProfileManagerUseCase() -> ProfileManagerUseCase {
        return DefaultProfileManagerUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                            manageFirebaseFireStoreUseCase: makeFireBaseFireStoreUseCase(),
                                            manageFirebaseStorageUseCase: makeFirebaseStorageUseCase())
    }
    
    func makeFirebaseStorageUseCase() -> ManageFirebaseStorageUseCase {
        return DefaultManageFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFirebaseStorageManagerRepository())
    }
    
    func makeFireBaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
    
    func makeFirebaseStorageManagerRepository() -> FireBaseStorageManagerRepository {
        return DefaultFirebaseStorageManagerRepository()
    }
    
    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
}
