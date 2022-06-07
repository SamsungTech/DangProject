//
//  OnboardingContentViewController.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/11.
//

import Foundation
import UIKit

class OnboardingContentViewController: UIViewController {
    
    private var imageView = UIImageView()
    var imageFile: String!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.frame = view.bounds
        guard let image = UIImage(named: imageFile) else {return}
        imageView.image = image
        
    }
}
