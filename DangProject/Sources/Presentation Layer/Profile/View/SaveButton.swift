//
//  SaveView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/18.
//

import UIKit

class SaveButton: UIView {
    private lazy var gradientBackgroundView: UIView = {
        let view = UIView()
        let gradient = CAGradientLayer()
        gradient.frame.size = CGSize(width: calculateXMax(), height: yValueRatio(25))
        gradient.colors = [
            UIColor.init(white: 1, alpha: 0).cgColor,
            UIColor.homeBoxColor.cgColor
        ]
        view.layer.addSublayer(gradient)
        
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .homeBoxColor
        return view
    }()
    
    private(set) lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .heavy)
        button.backgroundColor = .circleColorGreen
        button.viewRadius(cornerRadius: xValueRatio(15))
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

extension SaveButton {
    private func configureUI() {
        setUpGradientBackgroundView()
        setUpBackgroundView()
        setUpSaveButton()
    }
    
    private func setUpGradientBackgroundView() {
        addSubview(gradientBackgroundView)
        gradientBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            gradientBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gradientBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientBackgroundView.heightAnchor.constraint(equalToConstant: yValueRatio(25))
        ])
    }
    
    private func setUpBackgroundView() {
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: yValueRatio(80))
        ])
    }
    
    private func setUpSaveButton() {
        backgroundView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            saveButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: xValueRatio(30)),
            saveButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -xValueRatio(30)),
            saveButton.heightAnchor.constraint(equalToConstant: yValueRatio(50))
        ])
    }
}
