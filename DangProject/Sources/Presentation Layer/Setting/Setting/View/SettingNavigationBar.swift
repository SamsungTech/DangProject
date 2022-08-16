//
//  SettingNavigationBar.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import UIKit

class SettingNavigationBar: UIView {
    private lazy var settingLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: xValueRatio(25), weight: .heavy)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
        self.backgroundColor = .homeBoxColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingNavigationBar {
    private func setupLabel() {
        self.addSubview(settingLabel)
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: yValueRatio(10)),
            settingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20))
        ])
    }
    
    func setupSettingScrollViewTop() {
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.clear.cgColor
    }
    func setupSettingScrollViewScrolling() {
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
