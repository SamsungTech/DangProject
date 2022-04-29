import UIKit

class LoginDIContainer {
    
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController(viewModel: makeLoginViewModel(), firebaseAuthManager: makeFirebaseAuthManager())
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel()
    }
    
    func makeFirebaseAuthManager() -> FirebaseAuthManager {
        return DefaultFirebaseAuthManager()
    }
}
