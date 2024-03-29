//
//  DangTextFieldView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/20.
//

import UIKit

class BirthDateTextFieldView: UIView {
    private(set) lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(16), weight: .semibold)
        label.textColor = .customFontColorGray
        return label
    }()
    
    private lazy var textFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .homeBackgroundColor
        view.viewRadius(cornerRadius: xValueRatio(15))
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.2
        return view
    }()
    
    private(set) lazy var toolBarButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .circleColorGreen
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitle("확인", for: .normal)
        button.frame = CGRect(x: .zero,
                              y: .zero,
                              width: calculateXMax(),
                              height: yValueRatio(50))
        button.addTarget(self, action: #selector(okButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc func okButtonDidTap() {
        self.endEditing(true)
    }
    
    private(set) lazy var profileTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .semibold)
        textField.textColor = .init(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
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

extension BirthDateTextFieldView {
    private func configureUI() {
        setUpProfileLabel()
        setUpTextFieldBackgroundView()
        setUpProfileTextField()
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
            textFieldBackgroundView.heightAnchor.constraint(equalToConstant: yValueRatio(70))
        ])
    }
    
    private func setUpProfileTextField() {
        textFieldBackgroundView.addSubview(profileTextField)
        profileTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileTextField.topAnchor.constraint(equalTo: textFieldBackgroundView.topAnchor),
            profileTextField.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor, constant: xValueRatio(10)),
            profileTextField.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor, constant: -xValueRatio(10)),
            profileTextField.bottomAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor)
        ])
    }
}
