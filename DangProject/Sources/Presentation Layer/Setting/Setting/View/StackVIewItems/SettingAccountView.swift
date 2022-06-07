//
//  SettingAccountView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import UIKit

class SettingAccountView: UIButton {
    private(set) lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .white
        imageView.viewRadius(cornerRadius: xValueRatio(25))
        return imageView
    }()
    
    private(set) lazy var profileAccountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: xValueRatio(19), weight: .semibold)
        return label
    }()
    
    private lazy var profileCheckLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "내 계정 확인하기"
        label.font = UIFont.systemFont(ofSize: xValueRatio(14), weight: .semibold)
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

extension SettingAccountView {
    private func configureUI() {
        setUpView()
        setUpProfileImageView()
        setUpProfileAccountLabel()
        setUpProfileCheckLabel()
        setUpProfileRightArrowImageView()
    }
    
    private func setUpView() {
        self.addTarget(self, action: #selector(touchDownEvent(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(touchUpEvent(_:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    private func setUpProfileImageView() {
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(10)),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: xValueRatio(50)),
            profileImageView.heightAnchor.constraint(equalToConstant: yValueRatio(50))
        ])
    }
    
    private func setUpProfileAccountLabel() {
        addSubview(profileAccountLabel)
        profileAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileAccountLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: xValueRatio(10)),
            profileAccountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -yValueRatio(10))
        ])
    }
    
    private func setUpProfileCheckLabel() {
        addSubview(profileCheckLabel)
        profileCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileCheckLabel.leadingAnchor.constraint(equalTo: profileAccountLabel.leadingAnchor),
            profileCheckLabel.topAnchor.constraint(equalTo: profileAccountLabel.bottomAnchor, constant: yValueRatio(10))
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
    
    @objc private func touchDownEvent(_ sender: UIButton) {
        self.backgroundColor = .init(white: 1, alpha: 0.1)
    }
    
    @objc private func touchUpEvent(_ sender: UIButton) {
        self.backgroundColor = .homeBoxColor
    }
}
