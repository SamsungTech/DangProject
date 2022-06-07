//
//  ThemeStackView.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/20.
//

import UIKit

class ThemeStackView: UIView {
    private(set) lazy var rightMode: ThemeItem = {
        let item = ThemeItem()
        item.itemLabel.text = "밝은 모드"
        return item
    }()
    
    private(set) lazy var darkMode: ThemeItem = {
        let item = ThemeItem()
        item.itemLabel.text = "다크 모드"
        return item
    }()
    
    private(set) lazy var systemMode: ThemeItem = {
        let item = ThemeItem()
        item.itemLabel.text = "시스템 설정과 같이"
        return item
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ThemeStackView {
    private func configureUI() {
        setUpRightMode()
        setUpDarkMode()
        setUpSystemMode()
    }
    
    private func setUpRightMode() {
        addSubview(rightMode)
        rightMode.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightMode.topAnchor.constraint(equalTo: self.topAnchor),
            rightMode.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            rightMode.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightMode.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setUpDarkMode() {
        addSubview(darkMode)
        darkMode.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            darkMode.topAnchor.constraint(equalTo: rightMode.bottomAnchor),
            darkMode.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            darkMode.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            darkMode.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setUpSystemMode() {
        addSubview(systemMode)
        systemMode.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            systemMode.topAnchor.constraint(equalTo: darkMode.bottomAnchor),
            systemMode.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            systemMode.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            systemMode.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    func setUpRightModeImageView() {
        self.rightMode.checkMarkImageView.tintColor = .circleColorGreen
        self.darkMode.checkMarkImageView.tintColor = .clear
        self.systemMode.checkMarkImageView.tintColor = .clear
    }
    
    func setUpDarkModeImageView() {
        self.rightMode.checkMarkImageView.tintColor = .clear
        self.darkMode.checkMarkImageView.tintColor = .circleColorGreen
        self.systemMode.checkMarkImageView.tintColor = .clear
    }
    
    func setUpSystemModeImageView() {
        self.rightMode.checkMarkImageView.tintColor = .clear
        self.darkMode.checkMarkImageView.tintColor = .clear
        self.systemMode.checkMarkImageView.tintColor = .circleColorGreen
    }
}
