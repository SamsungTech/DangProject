//
//  SettingProfileImageButton.swift
//  DangProject
//
//  Created by 김동우 on 2022/08/27.
//

import UIKit

class SettingProfileImageButton: UIButton {
    private(set) lazy var profileImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        return imageView
    }()
    
    private(set) lazy var frontProfileImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.viewRadius(cornerRadius: xValueRatio(25))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setupSettingProfileImageButton()
        setupProfileImageButtonAutoLayout()
        setupFrontProfileImageButtonAutoLayout()
    }
    
    private func setupSettingProfileImageButton() {
        self.viewRadius(cornerRadius: xValueRatio(30))
        self.tintColor = .white
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.2
    }
    
    private func setupProfileImageButtonAutoLayout() {
        self.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: yValueRatio(7)),
            profileImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(10)),
            profileImageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xValueRatio(10)),
            profileImageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -yValueRatio(13))
        ])
    }
    
    private func setupFrontProfileImageButtonAutoLayout() {
        profileImageButton.addSubview(frontProfileImageButton)
        frontProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            frontProfileImageButton.topAnchor.constraint(equalTo: self.topAnchor),
            frontProfileImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            frontProfileImageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            frontProfileImageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
