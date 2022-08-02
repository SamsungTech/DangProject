import UIKit

class LoginDIContainer {
    
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController(viewModel: makeLoginViewModel())
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(manageFirebaseAuthUseCase: makeManageFirebaseAuthUseCase(),
                              manageFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase())
    }
    
    func makeManageFirebaseAuthUseCase() -> ManageFirebaseAuthUseCase {
        return DefaultManageFirebaseAuthUseCase(firebaseAuthRepository: makeFirebaseAuthRepository())
    }
    
    func makeManageFirebaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
    
    func makeFirebaseAuthRepository() -> FirebaseAuthManagerRepository {
        return DefaultFirebaseAuthManagerRepository()
    }
}
