//
//  ViewController.swift
//  TabBarTest
//
//  Created by 김성원 on 2022/01/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    
    func setupBackground() {
        view.backgroundColor = .white
        self.navigationItem.title = "First"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    
}

