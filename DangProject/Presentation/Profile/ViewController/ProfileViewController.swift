//
//  ProfileViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

protocol ProfileViewControllerProtocol: AnyObject {
    
}

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private weak var coordinator: Coordinator?
    private var viewModel: ProfileViewModelProtocol?
    private var dismissButton = UIButton()
    private var profileImageButton = UIButton()
    private var profileTitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .homeBackgroundColor
        setUpUI()
    }
    
    static func create(viewModel: ProfileViewModelProtocol,
                       coordinator: Coordinator) -> ProfileViewController {
        let viewController = ProfileViewController()
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        
        return viewController
    }
    
    private func setUpUI() {
        
    }
    
    private func configureProfileImageButton() {
    
    }
    
    private func configureDismissButton() {
        
    }
    
    private func configureProfileTitleLabel() {
        
    }
}
