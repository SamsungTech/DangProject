import Foundation
import UIKit

import RxSwift

class OnboardingViewModel {
    
    var viewControllers = [OnboardingContentViewController]()
    // Assets
    var contentImages = ["sugar.png", "hands.png", "bee.png", "arm.png"]
    var currentPageIndexObservable = BehaviorSubject(value: 0)
    var currentPage = 0
    
    func makeViewControllers() {
        for i in 0...contentImages.count-1 {
            let viewController = OnboardingContentViewController()
            viewController.imageFile = contentImages[i]
            viewController.pageIndex = i
            viewControllers.append(viewController)
        }
    }
    
    func changeIndex(to index: Int) {
        guard currentPage >= 0 && currentPage < viewControllers.count else { return }
        if currentPage < index {
            nextIndex()
        } else {
            previousIndex()
        }
    }
    
    func nextIndex() {
        currentPage = currentPage + 1
        currentPageIndexObservable.onNext(currentPage)
    }
    
    func previousIndex() {
        currentPage = currentPage - 1
        currentPageIndexObservable.onNext(currentPage)
    }
}
