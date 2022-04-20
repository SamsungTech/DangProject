//
//  GenderView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/17.
//

import UIKit

class GenderView: UIView {
    private(set) var leadingConstraint: NSLayoutConstraint?
    lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(16), weight: .semibold)
        label.textColor = .init(white: 1, alpha: 0.8)
        label.text = "성별"
        return label
    }()
    
    private lazy var genderBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .genderBackgroundViewColor
        view.viewRadius(cornerRadius: xValueRatio(35))
        return view
    }()
    
    private(set) lazy var selectedBackgroundView: UIView = {
        let view = UIView()
        view.viewRadius(cornerRadius: xValueRatio(30))
        view.backgroundColor = .genderSelectedBackgroundColor
        return view
    }()
    
    private(set) lazy var maleButton: UIButton = {
        let button = UIButton()
        button.setTitle("남", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .heavy)
        
        return button
    }()
    
    private(set) lazy var femaleButton: UIButton = {
        let button = UIButton()
        button.setTitle("여", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .heavy)
        
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

extension GenderView {
    private func configureUI() {
        setUpLabel()
        setUpGenderBackgroundView()
        setUpSelectedBackgroundView()
        setUpMaleButton()
        setUpFemaleButton()
    }
    
    private func setUpLabel() {
        addSubview(genderLabel)
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: self.topAnchor),
            genderLabel.heightAnchor.constraint(equalToConstant: yValueRatio(20)),
            genderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20))
        ])
    }
    
    private func setUpGenderBackgroundView() {
        addSubview(genderBackgroundView)
        genderBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genderBackgroundView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: yValueRatio(10)),
            genderBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)),
            genderBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xValueRatio(20)),
            genderBackgroundView.heightAnchor.constraint(equalToConstant: yValueRatio(70))
        ])
    }
    
    private func setUpSelectedBackgroundView() {
        genderBackgroundView.addSubview(selectedBackgroundView)
        selectedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        leadingConstraint = selectedBackgroundView.leadingAnchor.constraint(equalTo: genderBackgroundView.leadingAnchor, constant: xValueRatio(5))
        leadingConstraint?.isActive = true
        NSLayoutConstraint.activate([
            selectedBackgroundView.topAnchor.constraint(equalTo: genderBackgroundView.topAnchor, constant: xValueRatio(5)),
            selectedBackgroundView.widthAnchor.constraint(equalToConstant: xValueRatio(165)),
            selectedBackgroundView.bottomAnchor.constraint(equalTo: genderBackgroundView.bottomAnchor, constant: -xValueRatio(5))
        ])
    }
    
    private func setUpMaleButton() {
        genderBackgroundView.addSubview(maleButton)
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            maleButton.topAnchor.constraint(equalTo: genderBackgroundView.topAnchor),
            maleButton.leadingAnchor.constraint(equalTo: genderBackgroundView.leadingAnchor),
            maleButton.widthAnchor.constraint(equalToConstant: xValueRatio(175)),
            maleButton.bottomAnchor.constraint(equalTo: genderBackgroundView.bottomAnchor)
        ])
    }
    
    private func setUpFemaleButton() {
        genderBackgroundView.addSubview(femaleButton)
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            femaleButton.topAnchor.constraint(equalTo: genderBackgroundView.topAnchor),
            femaleButton.trailingAnchor.constraint(equalTo: genderBackgroundView.trailingAnchor),
            femaleButton.widthAnchor.constraint(equalToConstant: xValueRatio(175)),
            femaleButton.bottomAnchor.constraint(equalTo: genderBackgroundView.bottomAnchor)
        ])
    }
}
