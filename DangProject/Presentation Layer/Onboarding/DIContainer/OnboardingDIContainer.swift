import UIKit

class OnboardingDIContainer {
    
    func makeOnboardingViewController() -> OnboardingMasterViewController {
        return OnboardingMasterViewController(viewModel: makeOnboardingViewModel())
    }
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        return OnboardingViewModel()
    }
}
