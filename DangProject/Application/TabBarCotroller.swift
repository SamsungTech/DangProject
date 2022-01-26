//
//  TabBarCotroller.swift
//  DangProject
//
//  Created by 김성원 on 2022/01/26.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let homeTab: UIViewController
    let preferenceTab: UIViewController
    
    init(homeTab: UIViewController, prefrenceTab: UIViewController) {
        self.homeTab = homeTab
        self.preferenceTab = prefrenceTab
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbarButton()
        setupMiddleButton()
        
    }
    
    func setupTabbarButton() {
        homeTab.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        preferenceTab.tabBarItem = UITabBarItem(title: "Preferences", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        self.viewControllers = [homeTab, UIViewController(), preferenceTab].map{UINavigationController(rootViewController: $0)}

        self.delegate = self
    }
    
    func setupMiddleButton() {
        
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        var addButtonFrame = addButton.frame
        addButtonFrame.origin.y = self.view.bounds.height - addButtonFrame.height - 20
        addButtonFrame.origin.x = self.view.bounds.width/2 - addButtonFrame.size.width/2
        addButton.frame = addButtonFrame
        addButton.layer.cornerRadius = addButtonFrame.height/2
        let addButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 75, weight: .bold, scale: .large)
        let addButtonImage = UIImage(systemName: "face.smiling", withConfiguration: addButtonConfiguration)
        addButton.setImage(addButtonImage, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        self.view.addSubview(addButton)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func addButtonTapped() {
        print("tapped")
    }
}

extension TabBarController {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        if selectedIndex == 1 {
            return false
        }
        return true
    }
}
