import UIKit

class InputProfileDIContainer {
    
    func makeInputProfileViewController() -> InputProfileViewController {
        return InputProfileViewController(viewModel: makeInputProfileViewModel())
    }
    
    func makeInputProfileViewModel() -> InputProfileViewModel {
        return InputProfileViewModel(manageFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase())
    }
    
    func makeManageFirebaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
}
