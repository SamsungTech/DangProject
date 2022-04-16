import Foundation
import UIKit

class OnboardingViewModel {
    
    var viewControllers = [OnboardingContentViewController]()
    // Assets
    var contentImages = ["sugar.png", "hands.png", "bee.png", "arm.png"]
    
    func makeViewControllers() {
        for i in 0...contentImages.count-1 {
            let viewController = OnboardingContentViewController()
            viewController.imageFile = contentImages[i]
            viewController.pageIndex = i
            viewControllers.append(viewController)
        }
    }
    
    func closeOnboardingView() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: UserInfoKey.onboarding)
        userDefaults.synchronize()
            
    }
}
