//
//  CustomUIViewController.swift
//  DangProject
//
//  Created by 김성원 on 2022/08/16.
//

import Foundation
import UIKit

protocol CustomTabBarIsNeeded { }

class CustomViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self as? CustomTabBarIsNeeded != nil {
            showCustomTabBar()
        } else {
            hideCustomTabBar()
        }
    }
    
    private func showCustomTabBar() {
        guard let tabBarController = self.navigationController?.parent as? TabBarController else { return }
        tabBarController.showTabBar()
    }
    
    private func hideCustomTabBar() {
        guard let tabBarController = self.navigationController?.parent as? TabBarController else { return }
        tabBarController.hideTabBar()
    }
}
