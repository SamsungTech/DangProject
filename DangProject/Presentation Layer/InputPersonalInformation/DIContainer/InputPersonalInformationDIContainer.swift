import UIKit

class InputPersonalInformationDIContainer {
    
    func makeInputPersonalInformationViewController() -> InputPersonalInformationViewController {
        return InputPersonalInformationViewController(viewModel: makeInputPersonalInformationViewModel())
    }
    
    func makeInputPersonalInformationViewModel() -> InputPersonalInformationViewModel {
        return InputPersonalInformationViewModel(firebaseFireStoreUseCase: makeFirebaseFireStoreUseCase())
    }
    
    func makeFirebaseFireStoreUseCase() -> FirebaseFireStoreUseCase {
        return FirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
}
