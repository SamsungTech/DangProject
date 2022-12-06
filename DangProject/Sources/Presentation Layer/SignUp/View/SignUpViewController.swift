//
//  SignUpViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/12/06.
//

import UIKit

import RxSwift

class SignUpViewController: UIViewController {
    private let disposeBag = DisposeBag()
    weak var coordinator: SignUpCoordinator?
    private let viewModel: SignUpViewModel
    
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    
    private func setupUI() {
        
    }
    
}
