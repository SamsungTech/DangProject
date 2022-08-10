//
//  AccountStackView.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/17.
//

import UIKit

class AccountStackView: UIView {
    private(set) lazy var profileEditView: SettingStackViewItemsButton = {
        let button = SettingStackViewItemsButton()
        button.backgroundColor = .homeBoxColor
        button.itemLabel.text = "프로필 편집"
        return button
    }()
    
    private(set) lazy var myAccountLabel: AccountProfileEditView = {
        let button = AccountProfileEditView()
        button.backgroundColor = .homeBoxColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountStackView {
    private func configureUI() {
        setupProfileEditView()
        setupMyAccountLabel()
    }
    
    private func setupProfileEditView() {
        addSubview(profileEditView)
        profileEditView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileEditView.topAnchor.constraint(equalTo: self.topAnchor),
            profileEditView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileEditView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            profileEditView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setupMyAccountLabel() {
        addSubview(myAccountLabel)
        myAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myAccountLabel.topAnchor.constraint(equalTo: profileEditView.bottomAnchor),
            myAccountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            myAccountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            myAccountLabel.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    
}
