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
        return FirebaseAuthUseCase(firebaseAuthRepository: makeFirebaseAuthRepository())
    }
    
    func makeFirebaseFireStoreUseCase() -> FirebaseFireStoreUseCase {
        return FirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
    func makeFirebaseAuthRepository() -> FirebaseAuthManagerRepository {
        return DefaultFirebaseAuthManagerRepository()
    }
}
