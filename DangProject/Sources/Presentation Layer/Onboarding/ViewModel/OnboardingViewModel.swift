import Foundation
import UIKit

import RxSwift
import RxCocoa

protocol OnboardingViewModelInput {
    var currentPageIndexObservable: BehaviorSubject<Int> { get }
    var currentPage: Int { get }
    func changeIndex(to index: Int)
}

protocol OnboardingViewModelOutput {
    var viewControllers: [OnboardingContentViewController] { get }
    var contentImages: [String] { get }
    func nextIndex()
    func previousIndex()
}

protocol OnboardingViewModelProtocol: OnboardingViewModelInput, OnboardingViewModelOutput { }

class OnboardingViewModel {
    
    // MARK: - Init
    init() {
        makeViewControllers()
    }
    
    private func makeViewControllers() {
        for i in 0...contentImages.count-1 {
            let viewController = OnboardingContentViewController()
            viewController.imageFile = contentImages[i]
            viewController.pageIndex = i
            viewControllers.append(viewController)
        }
    }

    // MARK: - Input
    var currentPageIndexObservable = BehaviorRelay(value: 0)
    var currentPage = 0
    
    func changeIndex(to index: Int) {
        guard currentPage >= 0 && currentPage < viewControllers.count else { return }
        if currentPage < index {
            nextIndex()
        } else {
            previousIndex()
        }
    }

    func changeUserDefaultsOnboardingValue() {
        UserDefaults.standard.set(true, forKey: UserInfoKey.tutorialFinished)
    }
    // MARK: - Output
    var viewControllers = [OnboardingContentViewController]()
    var contentImages = ["sugar.png", "hands.png", "bee.png", "arm.png"]
    
    func nextIndex() {
        currentPage = currentPage + 1
        currentPageIndexObservable.accept(currentPage)
    }
    
    func previousIndex() {
        currentPage = currentPage - 1
        currentPageIndexObservable.accept(currentPage)
    }
}
