//
//  ProfileImageButton.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/14.
//

import UIKit

protocol ProfileImageButtonProtocol: AnyObject {
    func profileImageButtonTapped()
}

class ProfileImageButton: UIView {
    var delegate: ProfileImageButtonProtocol?
    private lazy var profileImageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .profileImageBackgroundColor
        view.viewRadius(cornerRadius: yValueRatio(62.5))
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    
    private lazy var ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private(set) lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.viewRadius(cornerRadius: yValueRatio(62.5))
        return imageView
    }()
    
    private lazy var profileSideBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .homeBoxColor
        view.viewRadius(cornerRadius: yValueRatio(17.5))
        return view
    }()
    
    private lazy var profileSideImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle.fill")
        imageView.tintColor = .customLabelColorBlack
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.homeBoxColor.cgColor
        imageView.viewRadius(cornerRadius: yValueRatio(17.5))
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

extension ProfileImageButton {
    private func configureUI() {
        setUpView()
        setUpProfileImageBackgroundView()
        setUpImageView()
        setUpProfileImageView()
        setUpProfileSideBackgroundView()
        setUpProfileSideImageView()
    }
    
    private func setUpView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageButtonDidTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setUpProfileImageBackgroundView() {
        addSubview(profileImageBackgroundView)
        profileImageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        profileImageBackgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageBackgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageBackgroundView.widthAnchor.constraint(equalToConstant: yValueRatio(125)).isActive = true
        profileImageBackgroundView.heightAnchor.constraint(equalToConstant: yValueRatio(125)).isActive = true
    }
    
    private func setUpImageView() {
        addSubview(ImageView)
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ImageView.widthAnchor.constraint(equalToConstant: yValueRatio(50)).isActive = true
        ImageView.heightAnchor.constraint(equalToConstant: yValueRatio(50)).isActive = true
    }
    
    private func setUpProfileImageView() {
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: yValueRatio(125)).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: yValueRatio(125)).isActive = true
    }
    
    private func setUpProfileSideBackgroundView() {
        addSubview(profileSideBackgroundView)
        profileSideBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        profileSideBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        profileSideBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileSideBackgroundView.widthAnchor.constraint(equalToConstant: yValueRatio(35)).isActive = true
        profileSideBackgroundView.heightAnchor.constraint(equalToConstant: yValueRatio(35)).isActive = true
    }
    
    private func setUpProfileSideImageView() {
        addSubview(profileSideImageView)
        bringSubviewToFront(profileSideImageView)
        profileSideImageView.translatesAutoresizingMaskIntoConstraints = false
        profileSideImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        profileSideImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileSideImageView.widthAnchor.constraint(equalToConstant: yValueRatio(35)).isActive = true
        profileSideImageView.heightAnchor.constraint(equalToConstant: yValueRatio(35)).isActive = true
    }
    
    @objc private func profileImageButtonDidTap() {
        delegate?.profileImageButtonTapped()
    }
}
