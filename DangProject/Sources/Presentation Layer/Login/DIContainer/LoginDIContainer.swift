import UIKit

class LoginDIContainer {
    
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController(viewModel: makeLoginViewModel())
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(firebaseAuthUseCase: makeFirebaseAuthUseCase(),
                              firebaseFireStoreUseCase: makeFirebaseFireStoreUseCase())
    }
    
    func makeFirebaseAuthUseCase() -> FirebaseAuthUseCase {
        return DefaultFirebaseAuthUseCase(firebaseAuthRepository: makeFirebaseAuthRepository())
    }
    
    func makeFirebaseFireStoreUseCase() -> FirebaseFireStoreUseCase {
        return DefaultFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
    func makeFirebaseAuthRepository() -> FirebaseAuthManagerRepository {
        return DefaultFirebaseAuthManagerRepository()
    }
}
