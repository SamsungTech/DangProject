//
//  SettingAppVersionView.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/13.
//

import UIKit

class SettingAppVersionView: UIButton {
    private(set) lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customLabelColorBlack
        label.font = UIFont.systemFont(ofSize: xValueRatio(16), weight: .semibold)
        return label
    }()
    
    private(set) lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customLabelColorBlack2
        label.font = UIFont.systemFont(ofSize: xValueRatio(17), weight: .semibold)
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

extension SettingAppVersionView {
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
        addSubview(versionLabel)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            versionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xValueRatio(20)),
            versionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
