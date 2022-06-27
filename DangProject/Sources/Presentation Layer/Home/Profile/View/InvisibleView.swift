//
//  InvisibleView.swift
//  DangProject
//
//  Created by 김동우 on 2022/06/27.
//

import UIKit

protocol InvisibleViewProtocol: AnyObject {
    func viewTapped()
}

class InvisibleView: UIView {
    var delegate: InvisibleViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension InvisibleView {
    private func configureUI() {
        setUpView()
    }
    
    private func setUpView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewDidTap() {
        delegate?.viewTapped()
    }
}
