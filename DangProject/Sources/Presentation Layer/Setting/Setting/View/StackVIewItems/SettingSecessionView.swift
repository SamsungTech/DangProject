//
//  SettingSecessionView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import UIKit

class SettingSecessionView: UIButton {
    private(set) lazy var profileAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴하기"
        label.textColor = .init(white: 1, alpha: 0.7)
        label.font = UIFont.systemFont(ofSize: xValueRatio(16), weight: .semibold)
        return label
    }()
    
    private(set) lazy var profileRightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .buttonColor
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingSecessionView {
    private func configureUI() {
        setUpSettingSecessionView()
        setUpProfileAccountLabel()
        setUpProfileRightArrowImageView()
    }
    
    private func setUpSettingSecessionView() {
        self.backgroundColor = .homeBoxColor
    }
    
    private func setUpProfileAccountLabel() {
        addSubview(profileAccountLabel)
        profileAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileAccountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)),
            profileAccountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setUpProfileRightArrowImageView() {
        addSubview(profileRightArrowImageView)
        profileRightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileRightArrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xValueRatio(20)),
            profileRightArrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileRightArrowImageView.widthAnchor.constraint(equalToConstant: xValueRatio(10)),
            profileRightArrowImageView.heightAnchor.constraint(equalToConstant: yValueRatio(20))
        ])
    }
}
