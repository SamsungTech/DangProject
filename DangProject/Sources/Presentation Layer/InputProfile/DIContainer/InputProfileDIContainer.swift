import UIKit

class InputProfileDIContainer {
    
    func makeInputProfileViewController() -> InputProfileViewController {
        return InputProfileViewController(viewModel: makeInputProfileViewModel())
    }
    
    func makeInputProfileViewModel() -> InputProfileViewModel {
        return InputProfileViewModel(manageFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase(),
                                     manageFirebaseStorageUseCase: makeFirebaseStorageUseCase())
    }
    
    func makeManageFirebaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFirebaseStorageUseCase() -> ManageFirebaseStorageUseCase {
        return DefaultManageFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFirebaseStorageManagerRepository())
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
    
    func makeFirebaseStorageManagerRepository() -> FireBaseStorageManagerRepository {
        return DefaultFirebaseStorageManagerRepository()
    }
}
