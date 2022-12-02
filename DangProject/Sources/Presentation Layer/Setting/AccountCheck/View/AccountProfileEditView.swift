//
//  AccountProfileEditButton.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import UIKit

class AccountProfileEditView: UIButton {
    private lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customFontColorGray
        label.font = UIFont.systemFont(ofSize: xValueRatio(16), weight: .semibold)
        label.text = "계정"
        return label
    }()
    
    private(set) lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customFontColorGray
        label.font = UIFont.systemFont(ofSize: xValueRatio(16), weight: .semibold)
        label.text = UserInfoKey.getUserDefaultsUID
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountProfileEditView {
    private func configureUI() {
        setupItemLabel()
        setupItemImageView()
    }
    
    private func setupItemLabel() {
        addSubview(itemLabel)
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)),
            itemLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setupItemImageView() {
        addSubview(accountLabel)
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xValueRatio(20)),
            accountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
