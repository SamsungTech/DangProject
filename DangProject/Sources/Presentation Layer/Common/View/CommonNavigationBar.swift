//
//  SettingNavigationBar.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import UIKit

class CommonNavigationBar: UIView {
    private(set) lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.viewRadius(cornerRadius: xValueRatio(15))
        button.tintColor = .customFontColorGray
        return button
    }()
    
    private(set) lazy var accountTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customFontColorBlack
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        self.backgroundColor = .homeBoxColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommonNavigationBar {
    private func configureUI() {
        setUpNavigationBar()
        setUpBackButton()
        setUpAccountTitleLabel()
    }
    
    private func setUpNavigationBar() {
        self.backgroundColor = .homeBoxColor
    }
    
    private func setUpBackButton() {
        addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -yValueRatio(10)),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(10)),
            backButton.widthAnchor.constraint(equalToConstant: xValueRatio(30)),
            backButton.heightAnchor.constraint(equalToConstant: yValueRatio(30))
        ])
    }
    
    private func setUpAccountTitleLabel() {
        addSubview(accountTitleLabel)
        accountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            accountTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

}
