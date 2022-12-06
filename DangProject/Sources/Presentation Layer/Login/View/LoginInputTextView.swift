//
//  LoginInputTextView.swift
//  DangProject
//
//  Created by 김동우 on 2022/12/06.
//

import UIKit

class LoginInputTextView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.1
        return textField
    }()
    
    private(set) lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: xValueRatio(16), weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupTitleLabel()
        setupTextField()
        setupWarningLabel()
    }
    
    private func setupTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    private func setupTextField() {
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: yValueRatio(10)),
            textField.heightAnchor.constraint(equalToConstant: yValueRatio(50)),
            textField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX-xValueRatio(40))
        ])
    }
    
    private func setupWarningLabel() {
        self.addSubview(warningLabel)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            warningLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            warningLabel.topAnchor.constraint(equalTo: textField.topAnchor, constant: yValueRatio(10))
        ])
    }
}
