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
    var calendarButton = UIImageView()
    fileprivate var barheightAnchor: NSLayoutConstraint?
    private let gradient = CAGradientLayer()
    var leftArrowButton = UIButton()
    var dateLabel = UILabel()
    var rightArrowButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        profileImageView.do {
            $0.image = UIImage(named: "231.png")
            $0.tintColor = .white
            $0.viewRadius(cornerRadius: 20)
        }
        calendarButton.do {
            $0.image = UIImage(systemName: "calendar")
            $0.tintColor = .white
        }
        leftArrowButton.do {
            $0.setImage(UIImage(systemName: "arrowtriangle.backward.fill"), for: .normal)
            $0.tintColor = .white
        }
        dateLabel.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: 17)
            $0.text = "2020년 2월 8일"
            $0.textAlignment = .center
        }
        rightArrowButton.do {
            $0.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
            $0.tintColor = .white
        }
    }
    private func layout() {
        [ profileImageView, leftArrowButton, rightArrowButton,
          dateLabel, calendarButton ].forEach() { self.addSubview($0) }
        
        profileImageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 40).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
            $0.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor).isActive = true
        }
        leftArrowButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
            $0.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        dateLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        }
        rightArrowButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.trailingAnchor.constraint(equalTo: calendarButton.leadingAnchor, constant: -20).isActive = true
            $0.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        calendarButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        }
    }
}

extension CustomNavigationBar {
    func setNavigationBarAnimation(completion: @escaping () -> Void) {}
    func setNavigationBarReturnAnimation() {}
}

extension UIView {
}
