//
//  AnimationTextField.swift
//  DangProject
//
//  Created by 김동우 on 2023/01/29.
//

import UIKit

class AnimationTextFieldView: UIView {
    private(set) lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(14), weight: .semibold)
        label.textColor = .customLabelColorBlack2
        return label
    }()
    
    private lazy var textFieldFrontView: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(frontViewDidTap(_:)),
                         for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var textFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .homeBackgroundColor
        view.viewRadius(cornerRadius: xValueRatio(15))
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.2
        return view
    }()
    
    lazy var profileTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: xValueRatio(15), weight: .semibold)
        textField.inputAccessoryView = toolBarButton
        textField.textColor = .customLabelColorBlack3
        textField.delegate = self
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
        button.addTarget(self, action: #selector(okButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func okButtonDidTap() {
        self.endEditing(true)
    }
    
    internal func configureUI() {
        setUpProfileLabel()
        setUpTextFieldBackgroundView()
        setUpProfileTextField()
        setupFrontView()
    }
    
    private func setUpProfileLabel() {
        addSubview(profileLabel)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: self.topAnchor),
            profileLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(35))
        ])
    }
    
    private func setUpTextFieldBackgroundView() {
        addSubview(textFieldBackgroundView)
        textFieldBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldBackgroundView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: yValueRatio(5)),
            textFieldBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(30)),
            textFieldBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xValueRatio(30)),
            textFieldBackgroundView.heightAnchor.constraint(equalToConstant: yValueRatio(55))
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
    
    private func setupFrontView() {
        textFieldBackgroundView.addSubview(textFieldFrontView)
        textFieldFrontView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldFrontView.topAnchor.constraint(equalTo: textFieldBackgroundView.topAnchor),
            textFieldFrontView.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor),
            textFieldFrontView.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor),
            textFieldFrontView.bottomAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor)
        ])
    }
}

extension AnimationTextFieldView {
    @objc private func frontViewDidTap(_ sender: UIButton) {
        if profileTextField.isEditing {
            self.profileTextField.endEditing(true)
        } else {
            self.profileTextField.becomeFirstResponder()
        }
    }
}

extension AnimationTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setupNameTextFieldState(isEditing: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setupNameTextFieldState(isEditing: false)
    }
    
    private func setupNameTextFieldState(isEditing: Bool) {
        switch isEditing {
        case true:
            animateEditMode()
            animateBorderColorToGreen()
        case false:
            animateNormalMode()
            animateBorderColorToGray()
        }
    }
    
    private func animateEditMode() {
        let borderWidth:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidth.fromValue = 0.2
        borderWidth.toValue = 2.0
        borderWidth.duration = 0.3
        borderWidth.isRemovedOnCompletion = false
        borderWidth.fillMode = CAMediaTimingFillMode.forwards
        textFieldBackgroundView.layer.add(borderWidth, forKey: "Width")
    }
    
    
    private func animateNormalMode() {
        let borderWidth:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidth.fromValue = 2.0
        borderWidth.toValue = 0.2
        borderWidth.duration = 0.3
        borderWidth.isRemovedOnCompletion = false
        borderWidth.fillMode = CAMediaTimingFillMode.forwards
        textFieldBackgroundView.layer.add(borderWidth, forKey: "Width")
    }
    
    
    private func animateBorderColorToGray() {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.circleColorGreen.cgColor
        animation.toValue = UIColor.darkGray.cgColor
        animation.duration = 0.3
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        textFieldBackgroundView.layer.add(animation, forKey: "borderColor")
    }
    
    private func animateBorderColorToGreen() {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.darkGray.cgColor
        animation.toValue = UIColor.circleColorGreen.cgColor
        animation.duration = 0.3
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        textFieldBackgroundView.layer.add(animation, forKey: "borderColor")
    }
}
