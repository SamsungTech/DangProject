//
//  MyTargetStackView.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import UIKit

class MyTargetView: UIButton {
    private lazy var targetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(white: 1, alpha: 0.7)
        label.font = UIFont.systemFont(ofSize: xValueRatio(18), weight: .semibold)
        label.text = "당신이 원하는 당 수치를 적어주세요."
        return label
    }()
    
    private(set) lazy var toolBar: ToolBarButton = {
        let toolBar = ToolBarButton()
        toolBar.setTitle("저장", for: .normal)
        return toolBar
    }()
    
    lazy var targetNumberTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: xValueRatio(80), weight: .semibold)
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        textField.inputAccessoryView = toolBar
        textField.placeholder = "숫자"
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var textFieldUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var numericalUnit: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: xValueRatio(18), weight: .semibold)
        label.text = "그램"
        return label
    }()
    
    private lazy var cheeringLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: xValueRatio(18), weight: .semibold)
        label.text = "You Can Do Anything!😉"
        label.alpha = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyTargetView {
    private func configureUI() {
        setUpTargetLabel()
        setUpTargetNumberLabel()
        setUpTextFieldUnderLine()
        setUpNumericalUnit()
        setUpCheeringLabel()
    }
    
    private func setUpTargetLabel() {
        addSubview(targetLabel)
        targetLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            targetLabel.topAnchor.constraint(equalTo: self.topAnchor),
            targetLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setUpTargetNumberLabel() {
        addSubview(targetNumberTextField)
        targetNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            targetNumberTextField.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: yValueRatio(50)),
            targetNumberTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setUpTextFieldUnderLine() {
        addSubview(textFieldUnderLine)
        textFieldUnderLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldUnderLine.topAnchor.constraint(equalTo: targetNumberTextField.bottomAnchor, constant: yValueRatio(5)),
            textFieldUnderLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textFieldUnderLine.leadingAnchor.constraint(equalTo: targetNumberTextField.leadingAnchor),
            textFieldUnderLine.trailingAnchor.constraint(equalTo: targetNumberTextField.trailingAnchor),
            textFieldUnderLine.heightAnchor.constraint(equalToConstant: yValueRatio(1))
        ])
    }
    
    private func setUpNumericalUnit() {
        addSubview(numericalUnit)
        numericalUnit.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numericalUnit.topAnchor.constraint(equalTo: textFieldUnderLine.bottomAnchor, constant: yValueRatio(15)),
            numericalUnit.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setUpCheeringLabel() {
        addSubview(cheeringLabel)
        cheeringLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cheeringLabel.topAnchor.constraint(equalTo: numericalUnit.bottomAnchor, constant: yValueRatio(30)),
            cheeringLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension MyTargetView {
    func animateLabel() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let self = self else { return }
            self.cheeringLabel.alpha = 1.0
        })
    }
    
    func setupSugarTarget(_ data: Int) {
        self.targetNumberTextField.text = String(data)
    }
}
