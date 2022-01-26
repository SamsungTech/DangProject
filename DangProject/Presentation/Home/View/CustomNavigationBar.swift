//
//  CustomNavigationBar.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/21.
//

import Foundation
import UIKit
import Then

class CustomNavigationBar: UIView {
    var profileImageView = UIImageView()
    var notification = UIImageView()
    fileprivate var barheightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
        self.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        profileImageView.do {
            $0.image = UIImage(named: "231.png")
            $0.tintColor = .white
            $0.viewRadius(cornerRadius: 20)
        }
        notification.do {
            $0.image = UIImage(systemName: "bell.fill")
            $0.tintColor = .white
        }
    }
    func layout() {
        [ profileImageView, notification ].forEach() { self.addSubview($0) }
        
        notification.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        }
        profileImageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 40).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
            $0.centerYAnchor.constraint(equalTo: notification.centerYAnchor).isActive = true
        }
    }
}

extension CustomNavigationBar {
    func setNavigationBarAnimation(completion: @escaping () -> Void) {}
    func setNavigationBarReturnAnimation() {}
}
