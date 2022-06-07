//
//  ProfileNavigationBar.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/18.
//

import UIKit

class ProfileNavigationBar: UIView {
    private lazy var profileTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: xValueRatio(25), weight: .heavy)
        return label
    }()
    
    private(set) lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileNavigationBar {
    private func configureUI() {
        setUpProfileTitleLabel()
        setUpDismissButton()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        backgroundColor = .homeBackgroundColor
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setUpProfileTitleLabel() {
        addSubview(profileTitleLabel)
        profileTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileTitleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: yValueRatio(10)),
            profileTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20))
        ])
    }
    
    private func setUpDismissButton() {
        addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: yValueRatio(10)),
            dismissButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -yValueRatio(20)),
            dismissButton.widthAnchor.constraint(equalToConstant: xValueRatio(30)),
            dismissButton.heightAnchor.constraint(equalToConstant: yValueRatio(30))
        ])
    }
}
