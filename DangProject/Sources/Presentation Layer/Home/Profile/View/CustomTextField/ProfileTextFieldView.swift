//
//  File.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/16.
//

import UIKit

class ProfileTextFieldView: UIView {
    var delegate: InputViewDelegate?
    private lazy var downArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .white
        return imageView
    }()
    
    private(set) lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(16), weight: .semibold)
        label.textColor = .init(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var textFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .profileTextFieldBackgroundColor
        view.viewRadius(cornerRadius: xValueRatio(15))
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.2
        return view
    }()
    
    private(set) lazy var toolBarButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .circleColorGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitle("확인", for: .normal)
        button.frame = CGRect(x: .zero,
                              y: .zero,
                              width: calculateXMax(),
                              height: yValueRatio(50))
        return button
    }()
    
    private(set) lazy var profileTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .semibold)
        textField.textColor = .white
        textField.inputAccessoryView = toolBarButton
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileTextFieldView {
    private func configureUI() {
        setUpView()
        setUpProfileLabel()
        setUpTextFieldBackgroundView()
        setUpDownArrowImageView()
        setUpProfileTextField()
    }
    
    private func setUpView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTextFieldViewDidTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setUpProfileLabel() {
        addSubview(profileLabel)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: self.topAnchor),
            profileLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20))
        ])
    }
    
    private func setUpTextFieldBackgroundView() {
        addSubview(textFieldBackgroundView)
        textFieldBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldBackgroundView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: yValueRatio(10)),
            textFieldBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)),
            textFieldBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xValueRatio(20)),
            textFieldBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -yValueRatio(10))
        ])
    }
    
    private func setUpDownArrowImageView() {
        textFieldBackgroundView.addSubview(downArrowImageView)
        downArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downArrowImageView.centerYAnchor.constraint(equalTo: textFieldBackgroundView.centerYAnchor),
            downArrowImageView.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor, constant: -xValueRatio(15)),
            downArrowImageView.widthAnchor.constraint(equalToConstant: xValueRatio(20)),
            downArrowImageView.heightAnchor.constraint(equalToConstant: yValueRatio(20))
        ])
    }
    
    private func setUpProfileTextField() {
        textFieldBackgroundView.addSubview(profileTextField)
        profileTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileTextField.centerYAnchor.constraint(equalTo: textFieldBackgroundView.centerYAnchor),
            profileTextField.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor, constant: xValueRatio(10))
        ])
    }
    
    @objc private func profileTextFieldViewDidTap() {
        delegate?.didTapView()
    }
}
