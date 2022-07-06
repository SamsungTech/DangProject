//
//  NameTextField.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import UIKit

class NameTextField: UIView {
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
    
    private(set) lazy var profileTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .semibold)
        textField.inputAccessoryView = toolBarButton
        return textField
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NameTextField {
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
            textFieldBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -yValueRatio(10))
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
}
