//
//  PreferenceCoordinaotr.swift
//  DangProject
//
//  Created by 김성원 on 2022/01/26.
//

import Foundation
import UIKit

class PreferenceCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var diContainer = PreferenceDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func firstStart() -> PreferenceViewController {
        return diContainer.makePreferenceViewController(coordinator: self)
    }
    
}
