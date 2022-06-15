import UIKit

class InputProfileDIContainer {
    
    func makeInputProfileViewController() -> InputProfileViewController {
        return InputProfileViewController(viewModel: makeInputProfileViewModel())
    }
    
    func makeInputProfileViewModel() -> InputProfileViewModel {
        return InputProfileViewModel(firebaseFireStoreUseCase: makeFirebaseFireStoreUseCase())
    }
    
    func makeFirebaseFireStoreUseCase() -> FirebaseFireStoreUseCase {
        return DefaultFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
}
