//
//  CustomProgressBar.swift
//  DangProject
//
//  Created by 김동우 on 2023/01/19.
//

import UIKit

enum CustomProgressBarStateColor: String {
    case low = "LOW"
    case middle = "MIDDLE"
    case high = "HIGH"
}

internal class CustomProgressBar: UIView {
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.viewRadius(cornerRadius: 175)
        return view
    }()
    
    private lazy var circleFrontView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.viewRadius(cornerRadius: 112.5)
        return view
    }()
    
    private lazy var frontView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var lowLabel: UILabel = {
        let label = UILabel()
        label.text = "LOW"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var highLabel: UILabel = {
        let label = UILabel()
        label.text = "HIGH"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var conicGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .conic
        gradient.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemGreen.cgColor,
            UIColor.systemYellow.cgColor,
            UIColor.systemRed.cgColor
        ]
        gradient.locations = [0, 0.375, 0.625, 0.875]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    private lazy var customArrowView: CustomArrowView = {
        let view = CustomArrowView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var frontCircleView: UIView = {
        let button = UIView()
        button.backgroundColor = .systemGreen
        button.viewRadius(cornerRadius: 72.5)
        return button
    }()
    
    private lazy var frontCircleLabel: UILabel = {
        let label = UILabel()
        label.text = "LOW"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupFanShapedView()
        setupCircleFrontView()
        setupCircleButton()
        setupFrontView()
        setupCustomArrowView()
        setupHighLabel()
        setupLowLabel()
        setupFrontCircleLabel()
    }
    
    internal func setupGradientLayer() {
        conicGradient.frame = circleView.bounds
        circleView.layer.addSublayer(conicGradient)
    }
    
    private func setupFanShapedView() {
        self.addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            circleView.widthAnchor.constraint(equalToConstant: 350),
            circleView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    private func setupCircleFrontView() {
        self.addSubview(circleFrontView)
        circleFrontView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleFrontView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleFrontView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            circleFrontView.widthAnchor.constraint(equalToConstant: 225),
            circleFrontView.heightAnchor.constraint(equalToConstant: 225)
        ])
    }
    
    private func setupFrontView() {
        self.addSubview(frontView)
        frontView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            frontView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            frontView.topAnchor.constraint(equalTo: circleView.centerYAnchor),
            frontView.widthAnchor.constraint(equalToConstant: 390),
            frontView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupHighLabel() {
        frontView.addSubview(highLabel)
        highLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            highLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor, constant: 15),
            highLabel.trailingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 1)
        ])
    }
    
    private func setupLowLabel() {
        frontView.addSubview(lowLabel)
        lowLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lowLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor, constant: 15),
            lowLabel.leadingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: 2.5)
        ])
    }
    
    private func setupCustomArrowView() {
        frontView.addSubview(customArrowView)
        customArrowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customArrowView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            customArrowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            customArrowView.widthAnchor.constraint(equalToConstant: 245),
            customArrowView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupCircleButton() {
        self.addSubview(frontCircleView)
        frontCircleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            frontCircleView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            frontCircleView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            frontCircleView.widthAnchor.constraint(equalToConstant: 145),
            frontCircleView.heightAnchor.constraint(equalToConstant: 145)
        ])
    }
    
    private func setupFrontCircleLabel() {
        self.addSubview(frontCircleLabel)
        frontCircleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            frontCircleLabel.centerXAnchor.constraint(equalTo: frontCircleView.centerXAnchor),
            frontCircleLabel.bottomAnchor.constraint(equalTo: frontView.topAnchor),
            frontCircleLabel.widthAnchor.constraint(equalToConstant: 100),
            frontCircleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension CustomProgressBar {
    internal func animateProgressBar(angle: CGFloat,
                                     state: CustomProgressBarStateColor) {
        startIndicatorAnimation(angle: angle)
        animateCircleColor(state: state)
    }
    
    private func startIndicatorAnimation(angle: CGFloat) {
        UIView.animate(withDuration: 2.0, animations: { [self] in
            self.customArrowView.transform = CGAffineTransform(rotationAngle: angle)
        })
    }
    
    private func animateCircleColor(state: CustomProgressBarStateColor) {
        switch state {
        case .low:
            colorAnimation(color: UIColor.systemGreen)
            setupCircleTextAtColorAnimation(text: state.rawValue)
        case .middle:
            colorAnimation(color: UIColor.systemYellow)
            setupCircleTextAtColorAnimation(text: state.rawValue)
        case .high:
            colorAnimation(color: UIColor.systemRed)
            setupCircleTextAtColorAnimation(text: state.rawValue)
        }
    }
    
    private func setupCircleTextAtColorAnimation(text: String) {
        self.frontCircleLabel.text = text
    }
    
    private func colorAnimation(color: UIColor) {
        UIView.animate(withDuration: 2.0) { [weak self] in
            self?.frontCircleView.backgroundColor = color
        }
    }
}
