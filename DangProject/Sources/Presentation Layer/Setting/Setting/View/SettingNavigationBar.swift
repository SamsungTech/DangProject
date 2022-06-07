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
        label.font = UIFont.systemFont(ofSize: xValueRatio(25), weight: .heavy)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel()
        self.backgroundColor = .homeBoxColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingNavigationBar {
    private func setUpLabel() {
        self.addSubview(settingLabel)
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: yValueRatio(10)),
            settingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20))
        ])
    }
    
    func setUpSettingScrollViewTop() {
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.clear.cgColor
    }
    func setUpSettingScrollViewScrolling() {
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
