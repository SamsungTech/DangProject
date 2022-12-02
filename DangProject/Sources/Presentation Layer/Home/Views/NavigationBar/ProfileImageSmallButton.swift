//
//  ProfileImageSmallButton.swift
//  DangProject
//
//  Created by 김동우 on 2022/08/02.
//

import UIKit

class ProfileImageSmallButton: UIButton {
    private(set) lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.viewRadius(cornerRadius: xValueRatio(20))
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
        setupProfileImageSmallButton()
        setupProfileImageView()
    }
    
    private func setupProfileImageSmallButton() {
        self.viewRadius(cornerRadius: xValueRatio(20))
        self.setImage(UIImage(systemName: "person.fill"), for: .normal)
        self.tintColor = .customFontColorBlack
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.2
    }
    
    private func setupProfileImageView() {
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupProfileImageViewImage(_ image: UIImage) {
        self.profileImageView.image = image
    }
}
