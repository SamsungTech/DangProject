//
//  ViewController3.swift
//  TabBarTest
//
//  Created by 김성원 on 2022/01/25.
//

import Foundation
import UIKit

class PreferenceViewController: UIViewController {

    weak var coordinator: PreferenceCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackGround()
    }
    
    func setupBackGround() {
        view.backgroundColor = .brown
        self.navigationItem.title = "Preference"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
}

